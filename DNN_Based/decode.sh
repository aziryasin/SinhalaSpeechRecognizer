
## Audio –> Feature Vectors
../../src/featbin/compute-mfcc-feats \
    --config=conf/mfcc.conf \
    scp:transcriptions/wav.scp \
    ark,scp:transcriptions/feats.ark,transcriptions/feats.scp


../../src/featbin/add-deltas \
    scp:transcriptions/feats.scp \
    ark:transcriptions/delta-feats.ark


## Trained GMM-HMM + Feature Vectors –> Lattice

../../src/gmmbin/gmm-latgen-faster \
    --word-symbol-table=exp/tri1/graph/words.txt \
    exp/tri1/final.mdl \
    exp/tri1/graph/HCLG.fst \
    ark:transcriptions/delta-feats.ark \
    ark,t:transcriptions/lattices.ark

## Lattice –> Best Path Through Lattice

../../src/latbin/lattice-best-path \
    --word-symbol-table=exp/tri1/graph/words.txt \
    ark:transcriptions/lattices.ark \
    ark,t:transcriptions/one-best.tra

## Best Path Intergers –> Best Path Words

utils/int2sym.pl -f 2- \
    exp/tri1/graph/words.txt \
    transcriptions/one-best.tra \
    > transcriptions/one-best-hypothesis.txt
