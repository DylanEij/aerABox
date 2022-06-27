% This function aims to write the includeDict file containing some
% variables relevant for the boundary conditions in OpenFOAM configuration
% files
%       Author  : Gabriel Buendia
%       Version : 1
% Inputs:
%       path          -> Path to save the file locally
%       wallname      -> Name of the aerodynamic profile
%       CofR          -> Center of rotation [xc yc zc]
%       writeInterval -> Writing interval
function ofWingForces(path,wallname,CofR,writeInterval) 
fileName = fopen(append(path,'wingForces'),'w');
string = (['#include "includeDict";\n\n'...
          'wingForces\n'...
          '{\n'...
	      '    patches             (',wallname,');\n'...
	      '    CofR                (',num2str(CofR(1)),' ',num2str(CofR(2)),' ',num2str(CofR(3)),');\n'...
	      '    writeControl 		timeStep;\n'...
	      '    writeInterval 		',num2str(writeInterval),';\n'...
	      '    type 				forces;\n'...
	      '    pName 				p;\n'...
	      '    UName 				U;\n'...
	      '    rho 			    rhoInf;\n'...
	      '    rhoInf 				$rho_s;\n'...
	      '    log 		        true;\n'...
          '}']);
fprintf(fileName,string);
fclose(fileName);
end