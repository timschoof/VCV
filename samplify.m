function samples = samplify(duration, SampFreq)

samples = floor(SampFreq*(duration/1000));
