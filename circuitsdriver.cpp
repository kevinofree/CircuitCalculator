/*
Author Information
  Author name: Kevin Ochoa
  Author email: ochoakevinm@gmail.com
Project Information
  Project title: Four-Device Circuit Calculator
  Purpose: This program calculates the current, total current, and total power of a parallel circuit using vector processing.
  Project files: circuits.asm, circuitsdriver.cpp
Module Information
  This module's call name: circuits.out
  Date last modified: 9-9-15
  Language: C++
  Purpose: This module is the driver for circuit_program.  This driver calls the function then outputs the total power value it receives.
  Filename: circuitsdriver.cpp
Translator Information:
   Gnu compiler: g++ -c -m64 -Wall -l circuitsdriver.lis -o circuitsdriver.o circuitsdriver.cpp
   Gnu linker:   g++ -m64 -o circuits.out circuitsdriver.o circuits.o 
References and Credits:
   Holliday, Floyd. Floating Point Input and Output. N.p., 1 July 2015. Web. 9 Sep. 2015. 
   Holliday, Floyd. Instructions acting on SSE and AVX. N.p., 27 August 2015. Web. 9 Sep. 2015. 
   Holliday, Floyd. Test Presence of AVX. N.p., 15 July 2015. Web. 9 Sep. 2015
Format Information
  Page width: 172 columns
  Begin Comments: 61
Permission information: No restrictions on posting this file online.
*/
//====== Beginning of circuitsdriver.cpp =========================================================================================================================================
#include <iostream>
#include <iomanip>
using namespace std;

extern "C" double circuit_program();

int main()
{
	double total_power = (0);
	cout << "Welcome to Electric Circuit Processing by Kevin Ochoa" << endl;
	total_power = circuit_program();
	cout << setprecision(18) << fixed << showpoint;
	cout << "The driver recieved this number: " << total_power << "." << endl;
	cout << "The driver will now return 0 to the operating system. Have a nice day." << endl;
	return 0;
}
//===== End of circuitsdriver.cpp ================================================================================================================================================
