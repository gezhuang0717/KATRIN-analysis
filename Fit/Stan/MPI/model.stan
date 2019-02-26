functions {
	real[] signal(real[] pars);
	real[] GetBkg();
	int[] GetData();
	int GetSubrunNum();
}

data {
	//int<lower=0> nbins;
	//vector[nbins] rate;
	//vector[nbins] error;
}

transformed data {
	int nsubrun = GetSubrunNum();
	int count[nsubrun] = GetData();
	real bkg[nsubrun] = GetBkg();

	real e1 = 12.6;
	real B_A = 2.68e-4;
	real B_S = 2.52;
	real B_max = 4.2;
	real A1 = 0.204;
	real A2 = 0.0556;
	real w1 = 1.85;
	real w2 = 12.5;
	real e2 = 14.3;
	real sigma = 3.4;
}

parameters {
	//real<lower=0, upper=100> mass;
	real<lower=18564, upper=18584> endpoint;
	real<lower=5e4, upper=50e4> A_sig;
	real<lower=10, upper=70> A_bkg;
	//real<lower=2.63, upper=2.73> B_A;
	//real<lower=24950, upper=25450> B_S;
	//real<lower=41500, upper=42500> B_max;
	//real<lower=0.199, upper=0.208> A1;
	//real<lower=0.0541, upper=0.0571> A2;
	//real<lower=1.75, upper=1.95> w1;
	//real<lower=12, upper=13> w2;
	//real<lower=14.2, upper=14.4> e2;
	//real<lower=3.05, upper=3.75> sigma;
}

transformed parameters {
	real dendpoint = endpoint - 18574;
}

model {
	real mass = 0;
	real pars[12] = {mass, endpoint, B_A, B_S, B_max, A1, A2, w1, w2, e1, e2, sigma*1e-18};
	real sig[nsubrun] = signal(pars);
	real pred[nsubrun];
	//vector[nbins+2] par_std;
	for(n in 1:nsubrun) {
		pred[n] = sig[n] * A_sig + A_bkg * bkg[n];
		//target += (rate[n]-pred[n]) * (pred[n]-rate[n]) / error[n] / error[n];
		//par_std[n] = (rate[n] - pred[n])/error[n];
		//print("Nbin: ", n, " Pred: ", pred[n], " count: ", count[n], " A_sig: ", A_sig);
	}
	count ~ poisson(pred);
//	B_A ~ normal(2.68, 0.01);
//	B_S ~ normal(2.52e4, 50);
//	B_max ~ normal(4.2e4, 100);
//	A1 ~ normal(0.204, 0.001);
//	A2 ~ normal(0.0556, 0.0003);
//	w1 ~ normal(1.85, 0.02);
//	w2 ~ normal(12.5, 0.1);
//	e2 ~ normal(14.3, 0.02);
//	sigma ~ normal(3.4, 0.07);
}

