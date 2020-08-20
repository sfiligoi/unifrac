#include "task_parameters.hpp"
#include <math.h>
#include <vector>
#include <stdint.h>
#include <stddef.h>

#ifndef __UNIFRAC_TASKS
#define __UNIFRAC_TASKS 1

namespace su {


#ifdef _OPENACC

  #ifndef SMALLGPU
  // defaultt on larger alignment, which improves performance on GPUs like V100
#define UNIFRAC_BLOCK 64
  #else
  // smaller GPUs prefer smaller allignment 
#define UNIFRAC_BLOCK 32
  #endif

#else

// CPUs don't need such a big alignment
#define UNIFRAC_BLOCK 8
#endif

    // Note: This adds a copy, which is suboptimal
    //       But was the easiest way to get a contiguous buffer
    //       And it does allow for fp32 compute, when desired
    template<class TFloat>
    class UnifracTaskVector {
    private:
      std::vector<double*> &dm_stripes;
      const su::task_parameters* const task_p;

    public:
      const unsigned int start_idx;
      const unsigned int n_samples;
      const uint64_t  n_samples_r;
      TFloat* const buf;

      UnifracTaskVector(std::vector<double*> &_dm_stripes, const su::task_parameters* _task_p)
      : dm_stripes(_dm_stripes), task_p(_task_p)
      , start_idx(task_p->start), n_samples(task_p->n_samples)
      , n_samples_r(((n_samples + UNIFRAC_BLOCK-1)/UNIFRAC_BLOCK)*UNIFRAC_BLOCK) // round up
      , buf((dm_stripes[start_idx]==NULL) ? NULL : new TFloat[n_samples_r*(task_p->stop-start_idx)]) // dm_stripes could be null, in which case keep it null
      {
        TFloat* const ibuf = buf;
        if (ibuf != NULL) {
#ifdef _OPENACC
          const uint64_t bufels = n_samples_r * (task_p->stop-start_idx);
#endif
          for(unsigned int stripe=start_idx; stripe < task_p->stop; stripe++) {
             double * dm_stripe = dm_stripes[stripe];
             TFloat * buf_stripe = this->operator[](stripe);
             for(unsigned int j=0; j<n_samples; j++) {
                // Note: We could probably just initialize to zero
                buf_stripe[j] = dm_stripe[j];
             }
             for(unsigned int j=n_samples; j<n_samples_r; j++) {
                // Avoid NaNs
                buf_stripe[j] = 0.0;
             }
           }
#ifdef _OPENACC
#pragma acc enter data copyin(ibuf[:bufels])
#endif    
        }
      }

      TFloat * operator[](unsigned int idx) { return buf+((idx-start_idx)*n_samples_r);}
      const TFloat * operator[](unsigned int idx) const { return buf+((idx-start_idx)*n_samples_r);}


      ~UnifracTaskVector()
      {
        TFloat* const ibuf = buf;
        if (ibuf != NULL) {
#ifdef _OPENACC
          const uint64_t bufels = n_samples_r * (task_p->stop-start_idx); 
#pragma acc exit data copyout(ibuf[:bufels])
#endif    
          for(unsigned int stripe=start_idx; stripe < task_p->stop; stripe++) {
             double * dm_stripe = dm_stripes[stripe];
             TFloat * buf_stripe = this->operator[](stripe);
             for(unsigned int j=0; j<n_samples; j++) {
              dm_stripe[j] = buf_stripe[j];
             }
          }
          delete [] buf;
        }
      }

    private:
      UnifracTaskVector() = delete;
      UnifracTaskVector operator=(const UnifracTaskVector&other) const = delete;
    };

    // Base task class to be shared by all tasks
    template<class TFloat, class TEmb>
    class UnifracTaskBase {
      public:
        UnifracTaskVector<TFloat> dm_stripes;
        UnifracTaskVector<TFloat> dm_stripes_total;

        const su::task_parameters* task_p;

        const unsigned int max_embs;
        TEmb * const embedded_proportions;

        UnifracTaskBase(std::vector<double*> &_dm_stripes, std::vector<double*> &_dm_stripes_total, unsigned int _max_embs, const su::task_parameters* _task_p)
        : dm_stripes(_dm_stripes,_task_p), dm_stripes_total(_dm_stripes_total,_task_p), task_p(_task_p)
        , max_embs(_max_embs), embedded_proportions(initialize_embedded(dm_stripes.n_samples_r,_max_embs)) {}

        /* remove
        // Note: not const, since they share a mutable state
        UnifracTaskBase(UnifracTaskBase &baseObj)
        : dm_stripes(baseObj.dm_stripes), dm_stripes_total(baseObj.dm_stripes_total), task_p(baseObj.task_p) {}
        */

        virtual ~UnifracTaskBase()
        {
#ifdef _OPENACC
          const uint64_t  n_samples_r = dm_stripes.n_samples_r;
          uint64_t bsize = n_samples_r * max_embs;
#pragma acc exit data delete(embedded_proportions[:bsize])
#endif    
          free(embedded_proportions);
        }

        void sync_embedded_proportions(unsigned int filled_embs)
        {
#ifdef _OPENACC
          const uint64_t  n_samples_r = dm_stripes.n_samples_r;
          uint64_t bsize = n_samples_r * filled_embs;
#pragma acc update device(embedded_proportions[:bsize])
#endif
        }

        static TEmb *initialize_embedded(const uint64_t  n_samples_r, uint64_t max_embs) {
          uint64_t bsize = n_samples_r * max_embs;

          TEmb* buf = NULL;
          int err = posix_memalign((void **)&buf, 4096, sizeof(TEmb) * bsize);
          if(buf == NULL || err != 0) {
            fprintf(stderr, "Failed to allocate %zd bytes, err %d; [%s]:%d\n",
                    sizeof(TEmb) * bsize, err, __FILE__, __LINE__);
             exit(EXIT_FAILURE);
          }
#pragma acc enter data create(buf[:bsize])
          return buf;
        }

        template<class TOut> void embed_proportions_straight(TOut* __restrict__ out, const double* __restrict__ in, unsigned int emb)
        {
          const unsigned int n_samples  = dm_stripes.n_samples;
          const uint64_t n_samples_r  = dm_stripes.n_samples_r;
          const uint64_t offset = emb * n_samples_r;

          for(unsigned int i = 0; i < n_samples; i++) {
            out[offset + i] = in[i];
          }

          // avoid NaNs
          for(unsigned int i = n_samples; i < n_samples_r; i++) {
            out[offset + i] = 1.0;
          }
        }
        template<class TOut> void embed_proportions_bool(TOut* __restrict__ out, const double* __restrict__ in, unsigned int emb)
        {
          const unsigned int n_samples  = dm_stripes.n_samples;
          const uint64_t n_samples_r  = dm_stripes.n_samples_r;
          const uint64_t offset = emb * n_samples_r;

          for(unsigned int i = 0; i < n_samples; i++) {
            out[offset + i] = (in[i] > 0);
          }

          // avoid NaNs
          for(unsigned int i = n_samples; i < n_samples_r; i++) {
            out[offset + i] = 0;
          }
        }

    };

    /* void su::unifrac tasks
     *
     * all methods utilize the same function signature. that signature is as follows:
     *
     * dm_stripes vector<double> the stripes of the distance matrix being accumulated 
     *      into for unique branch length
     * dm_stripes vector<double> the stripes of the distance matrix being accumulated 
     *      into for total branch length (e.g., to normalize unweighted unifrac)
     * embedded_proportions <double*> the proportions vector for a sample, or rather
     *      the counts vector normalized to 1. this vector is embedded as it is 
     *      duplicated: if A, B and C are proportions for features A, B, and C, the
     *      vector will look like [A B C A B C].
     * length <double> the branch length of the current node to its parent.
     * task_p <task_parameters*> task specific parameters.
     */

    template<class TFloat, class TEmb>
    class UnifracTask : public UnifracTaskBase<TFloat,TEmb> {
      protected:
#ifdef _OPENACC

        // The parallel nature of GPUs needs a largish step
  #ifndef SMALLGPU
        // default to larger step, which makes a big difference for bigger GPUs like V100
        static const unsigned int step_size = 32;
  #else
        // smaller GPUs prefer a slightly smaller step
        static const unsigned int step_size = 16;
  #endif
#else
        // The serial nature of CPU cores prefers a small step
        static const unsigned int step_size = 4;
#endif

      public:

        UnifracTask(std::vector<double*> &_dm_stripes, std::vector<double*> &_dm_stripes_total, unsigned int _max_embs, const su::task_parameters* _task_p)
        : UnifracTaskBase<TFloat,TEmb>(_dm_stripes, _dm_stripes_total, _max_embs, _task_p) {}

        /* delete
        UnifracTask(UnifracTaskBase<TFloat> &baseObj, const TEmb * _embedded_proportions, unsigned int _max_embs)
        : UnifracTaskBase<TFloat>(baseObj)
        , embedded_proportions(_embedded_proportions), max_embs(_max_embs) {}
        */
      

       virtual ~UnifracTask() {}

       virtual void embed_proportions(const double* __restrict__ in, unsigned int emb) = 0;
       virtual void run(unsigned int filled_embs, const TFloat * __restrict__ length) = 0;
    };


    template<class TFloat>
    class UnifracUnnormalizedWeightedTask : public UnifracTask<TFloat,TFloat> {
      public:
        UnifracUnnormalizedWeightedTask(std::vector<double*> &_dm_stripes, std::vector<double*> &_dm_stripes_total, unsigned int _max_embs, const su::task_parameters* _task_p)
        : UnifracTask<TFloat,TFloat>(_dm_stripes,_dm_stripes_total,_max_embs,_task_p) {}

        virtual void embed_proportions(const double* __restrict__ in, unsigned int emb) { _embed_proportions(in,emb);}
        virtual void run(unsigned int filled_embs, const TFloat * __restrict__ length) {_run(filled_embs, length);}

        void _embed_proportions(const double* __restrict__ in, unsigned int emb) { this->embed_proportions_straight(this->embedded_proportions,in,emb);}
        void _run(unsigned int filled_embs, const TFloat * __restrict__ length);
    };
    template<class TFloat>
    class UnifracNormalizedWeightedTask : public UnifracTask<TFloat,TFloat> {
      public:
        UnifracNormalizedWeightedTask(std::vector<double*> &_dm_stripes, std::vector<double*> &_dm_stripes_total, unsigned int _max_embs, const su::task_parameters* _task_p)
        : UnifracTask<TFloat,TFloat>(_dm_stripes,_dm_stripes_total,_max_embs,_task_p) {}

        virtual void embed_proportions(const double* __restrict__ in, unsigned int emb) { _embed_proportions(in,emb);}
        virtual void run(unsigned int filled_embs, const TFloat * __restrict__ length) {_run(filled_embs, length);}

        void _embed_proportions(const double* __restrict__ in, unsigned int emb) { this->embed_proportions_straight(this->embedded_proportions,in,emb);}
        void _run(unsigned int filled_embs, const TFloat * __restrict__ length);
    };
    template<class TFloat>
    class UnifracUnweightedTask : public UnifracTask<TFloat,uint8_t> {
      public:
        UnifracUnweightedTask(std::vector<double*> &_dm_stripes, std::vector<double*> &_dm_stripes_total, unsigned int _max_embs, const su::task_parameters* _task_p)
        : UnifracTask<TFloat, uint8_t>(_dm_stripes,_dm_stripes_total,_max_embs,_task_p)
        , embedded_packed(UnifracTaskBase<TFloat,uint32_t>::initialize_embedded(this->dm_stripes.n_samples_r,(_max_embs+31)/32))  {}

        virtual ~UnifracUnweightedTask()
        {
#ifdef _OPENACC
          const uint64_t  n_samples_r = this->dm_stripes.n_samples_r;
          uint64_t bsize = n_samples_r * ((this->max_embs+31)/32); // always rounded up
#pragma acc exit data delete(embedded_packed[:bsize])
#endif
          free(embedded_packed);
        }

        virtual void embed_proportions(const double* __restrict__ in, unsigned int emb) { _embed_proportions(in,emb);}
        virtual void run(unsigned int filled_embs, const TFloat * __restrict__ length) {_run(filled_embs, length);}

        void _embed_proportions(const double* __restrict__ in, unsigned int emb) { this->embed_proportions_bool(this->embedded_proportions,in,emb);}
        void _run(unsigned int filled_embs, const TFloat * __restrict__ length);
      private:
        // temp work buffer
        uint32_t * const embedded_packed;

    };
    template<class TFloat>
    class UnifracGeneralizedTask : public UnifracTask<TFloat,TFloat> {
      public:
        UnifracGeneralizedTask(std::vector<double*> &_dm_stripes, std::vector<double*> &_dm_stripes_total, unsigned int _max_embs, const su::task_parameters* _task_p)
        : UnifracTask<TFloat,TFloat>(_dm_stripes,_dm_stripes_total,_max_embs,_task_p) {}

        virtual void embed_proportions(const double* __restrict__ in, unsigned int emb) { _embed_proportions(in,emb);}
        virtual void run(unsigned int filled_embs, const TFloat * __restrict__ length) {_run(filled_embs, length);}

        void _embed_proportions(const double* __restrict__ in, unsigned int emb) { this->embed_proportions_straight(this->embedded_proportions,in,emb);}
        void _run(unsigned int filled_embs, const TFloat * __restrict__ length);
    };

    /* void su::unifrac_vaw tasks
     *
     * all methods utilize the same function signature. that signature is as follows:
     *
     * dm_stripes vector<double> the stripes of the distance matrix being accumulated 
     *      into for unique branch length
     * dm_stripes vector<double> the stripes of the distance matrix being accumulated 
     *      into for total branch length (e.g., to normalize unweighted unifrac)
     * embedded_proportions <double*> the proportions vector for a sample, or rather
     *      the counts vector normalized to 1. this vector is embedded as it is 
     *      duplicated: if A, B and C are proportions for features A, B, and C, the
     *      vector will look like [A B C A B C].
     * embedded_counts <double*> the counts vector embedded in the same way and order as
     *      embedded_proportions. the values of this array are unnormalized feature 
     *      counts for the subtree.
     * sample_total_counts <double*> the total unnormalized feature counts for all samples
     *      embedded in the same way and order as embedded_proportions.
     * length <double> the branch length of the current node to its parent.
     * task_p <task_parameters*> task specific parameters.
     */
    template<class TFloat, class TEmb>
    class UnifracVawTask : public UnifracTaskBase<TFloat,TEmb> {
      protected:
#ifdef _OPENACC
        // The parallel nature of GPUs needs a largish step
  #ifndef SMALLGPU
        // default to larger step, which makes a big difference for bigger GPUs like V100
        static const unsigned int step_size = 32;
  #else
        // smaller GPUs prefer a slightly smaller step
        static const unsigned int step_size = 16;
  #endif
#else
        // The serial nature of CPU cores prefers a small step
        static const unsigned int step_size = 4;
#endif

      public:
        TFloat * const embedded_counts;
        const TFloat * const sample_total_counts;

        UnifracVawTask(std::vector<double*> &_dm_stripes, std::vector<double*> &_dm_stripes_total, 
                    const TFloat * _sample_total_counts,
                    unsigned int _max_embs, const su::task_parameters* _task_p)
        : UnifracTaskBase<TFloat,TEmb>(_dm_stripes, _dm_stripes_total, _max_embs, _task_p)
        , embedded_counts(UnifracTaskBase<TFloat,TFloat>::initialize_embedded(this->dm_stripes.n_samples_r,_max_embs)), sample_total_counts(_sample_total_counts) {}


        /* delete
        UnifracVawTask(UnifracTaskBase<TFloat> &baseObj, 
                    const TEmb * _embedded_proportions, const TFloat * _sample_total_counts, unsigned int _max_embs)
        : UnifracTaskBase<TFloat>(baseObj)
        , embedded_proportions(_embedded_proportions), embedded_counts(initialize_embedded<TFloat>()), sample_total_counts(_sample_total_counts), max_embs(_max_embs) {}
        */


       virtual ~UnifracVawTask() {}

       void sync_embedded_counts(unsigned int filled_embs)
       {
#ifdef _OPENACC
          const uint64_t  n_samples_r = this->dm_stripes.n_samples_r;
          uint64_t bsize = n_samples_r * filled_embs;
#pragma acc update device(embedded_counts[:bsize])
#endif
       }

       void sync_embedded(unsigned int filled_embs) { this->sync_embedded_proportions(filled_embs); this->sync_embedded_counts(filled_embs);}

       virtual void embed(const double* __restrict__ in_proportions, const double* __restrict__ in_counts, unsigned int emb) = 0;

       virtual void run(unsigned int filled_embs, const TFloat * __restrict__ length) = 0;
    };

    template<class TFloat>
    class UnifracVawUnnormalizedWeightedTask : public UnifracVawTask<TFloat,TFloat> {
      public:
        UnifracVawUnnormalizedWeightedTask(std::vector<double*> &_dm_stripes, std::vector<double*> &_dm_stripes_total, 
                    const TFloat * _sample_total_counts, 
                    unsigned int _max_embs, const su::task_parameters* _task_p)
        : UnifracVawTask<TFloat,TFloat>(_dm_stripes,_dm_stripes_total,_sample_total_counts,_max_embs,_task_p) {}

        virtual void embed(const double* __restrict__ in_proportions, const double* __restrict__ in_counts, unsigned int emb) {_embed(in_proportions, in_counts, emb);}
        virtual void run(unsigned int filled_embs, const TFloat * __restrict__ length) {_run(filled_embs, length);}

        void _embed(const double* __restrict__ in_proportions, const double* __restrict__ in_counts, unsigned int emb) {
          this->embed_proportions_straight(this->embedded_proportions,in_proportions,emb);
          this->embed_proportions_straight(this->embedded_counts,in_counts,emb);
        }

        void _run(unsigned int filled_embs, const TFloat * __restrict__ length);
    };
    template<class TFloat>
    class UnifracVawNormalizedWeightedTask : public UnifracVawTask<TFloat,TFloat> {
      public:
        UnifracVawNormalizedWeightedTask(std::vector<double*> &_dm_stripes, std::vector<double*> &_dm_stripes_total, 
                    const TFloat * _sample_total_counts, 
                    unsigned int _max_embs, const su::task_parameters* _task_p)
        : UnifracVawTask<TFloat,TFloat>(_dm_stripes,_dm_stripes_total,_sample_total_counts,_max_embs,_task_p) {}

        virtual void embed(const double* __restrict__ in_proportions, const double* __restrict__ in_counts, unsigned int emb) {_embed(in_proportions, in_counts, emb);}
        virtual void run(unsigned int filled_embs, const TFloat * __restrict__ length) {_run(filled_embs, length);}

        void _embed(const double* __restrict__ in_proportions, const double* __restrict__ in_counts, unsigned int emb) {
          this->embed_proportions_straight(this->embedded_proportions,in_proportions,emb);
          this->embed_proportions_straight(this->embedded_counts,in_counts,emb);
        }
        void _run(unsigned int filled_embs, const TFloat * __restrict__ length);
    };
    template<class TFloat>
    class UnifracVawUnweightedTask : public UnifracVawTask<TFloat,uint8_t> {
      public:
        UnifracVawUnweightedTask(std::vector<double*> &_dm_stripes, std::vector<double*> &_dm_stripes_total, 
                    const TFloat * _sample_total_counts, 
                    unsigned int _max_embs, const su::task_parameters* _task_p)
        : UnifracVawTask<TFloat,uint8_t>(_dm_stripes,_dm_stripes_total,_sample_total_counts,_max_embs,_task_p) {}

        virtual void embed(const double* __restrict__ in_proportions, const double* __restrict__ in_counts, unsigned int emb) {_embed(in_proportions, in_counts, emb);}
        virtual void run(unsigned int filled_embs, const TFloat * __restrict__ length) {_run(filled_embs, length);}

        void _embed(const double* __restrict__ in_proportions, const double* __restrict__ in_counts, unsigned int emb) {
          this->embed_proportions_bool(this->embedded_proportions,in_proportions,emb);
          this->embed_proportions_straight(this->embedded_counts,in_counts,emb);
        }
        void _run(unsigned int filled_embs, const TFloat * __restrict__ length);
    };
    template<class TFloat>
    class UnifracVawGeneralizedTask : public UnifracVawTask<TFloat,TFloat> {
      public:
        UnifracVawGeneralizedTask(std::vector<double*> &_dm_stripes, std::vector<double*> &_dm_stripes_total,
                    const TFloat * _sample_total_counts, 
                    unsigned int _max_embs, const su::task_parameters* _task_p)
        : UnifracVawTask<TFloat,TFloat>(_dm_stripes,_dm_stripes_total,_sample_total_counts,_max_embs,_task_p) {}

        virtual void embed(const double* __restrict__ in_proportions, const double* __restrict__ in_counts, unsigned int emb) {_embed(in_proportions, in_counts, emb);}
        virtual void run(unsigned int filled_embs, const TFloat * __restrict__ length) {_run(filled_embs, length);}

        void _embed(const double* __restrict__ in_proportions, const double* __restrict__ in_counts, unsigned int emb) {
          this->embed_proportions_straight(this->embedded_proportions,in_proportions,emb);
          this->embed_proportions_straight(this->embedded_counts,in_counts,emb);
        }
        void _run(unsigned int filled_embs, const TFloat * __restrict__ length);
    };

}

#endif
