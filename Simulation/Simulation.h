/*
	 Simulate the detected spectrum, with y axis being decay rate.
	 Poisson distribution in each bin is approximated to be a gaussian. (Minimum entries being >10000)

	 Weiran, Nov.17, 2018.
*/

#ifndef Simulation_h
#define Simulation_h

#include <iostream>
#include "../Detect/Detect.h"
#include "../Configure/Configure.h"
#include "../Spectrum/Spectrum.h"

using namespace std;

class Simulation
{
	public:
		Simulation() {
			rndm = new TRandom3();
		}

		~Simulation() {
			delete rndm;
		}

		void SetMagnetic(double B_A, double B_S, double B_max) {
			detect.SetMagnetic(B_A, B_S, B_max);
		}

		double* Generate(double mass, double endpoint, int nvoltage, double* voltage, double* time, double A_sig=1, double A_bkg=1) {
			double* theory = detect.DetSpec(mass, endpoint, nvoltage, voltage);
			double* sim = new double[nvoltage];
			for(int n=0; n<nvoltage; n++) {
				double signal = A_sig * theory[n] * time[n];
				double bkg = A_bkg * katrin.Bkg_rate * time[n];
				long int entries = (long int)(rndm->PoissonD(signal + bkg));
				sim[n] = entries;
			}
			delete theory;
			return sim;
		}

		/* Asimov data returns event rate for each point. */
		double* Asimov(double mass, double endpoint, int nvoltage, double* voltage, double A_sig=1, double A_bkg=1) { // For discrete data.
			double* theory = detect.DetSpec(mass, endpoint, nvoltage, voltage);
			double* asimov = new double[nvoltage];
			for(int n=0; n<nvoltage; n++) {
				double signal = A_sig * theory[n];
				double bkg = A_bkg * katrin.Bkg_rate;
				double entries = signal + bkg;
				asimov[n] = entries;
			}
			delete theory;
			return asimov;
		}

	private:
		KATRIN katrin;
		Detect detect;
		Spectrum spec;
		TRandom3* rndm;

};

#endif
