% This function aims to import the volume mesh from Pointwise to openFOAM
% format. It is made by dafault for the case in which the wing is simulated
% within a box farfield without the symmetry option on
%       Author  : Gabriel Buendia
%       Version : 1
% Inputs:
%      ID            -> ID of the already existing bulk data entity
%      numberDomains -> Number of domains the aerodynamic profile is composed of
%      dimension     -> '2D' or '3D'
%      path          -> String that specifies where the mesh is exported to
% Outputs:
%      exportCommand -> String containing the command to export the mesh to
%                       openFOAM
function exportCommand = pwExportOPF(ID,numberDomains,dimension,path)
string = '$_TMP(PW_5) apply [list ';
for i = 1:numberDomains
    if i < numberDomains
        auxstring = append('[list $_BL(',num2str(ID),') [pw::GridEntity getByName dom-',num2str(i),']] ');
    else
        auxstring = append('[list $_BL(',num2str(ID),') [pw::GridEntity getByName dom-',num2str(i),']]]\n');
    end
    string = append(string,auxstring);
end
exportCommand = append(['pw::Application setCAESolver OpenFOAM 3\n' ...
    'pw::Application markUndoLevel {Set Dimension ',dimension,'}\n' ...
    'set _TMP(PW_1) [pw::BoundaryCondition create]\n' ...
    'pw::Application markUndoLevel {Create BC}\n' ...
    'unset _TMP(PW_1)\n' ...
    'set _TMP(PW_1) [pw::BoundaryCondition getByName bc-2]\n' ...
    '$_TMP(PW_1) setName inlet\n' ...
    '$_TMP(PW_1) setPhysicalType -usage CAE patch\n' ...
    'pw::Application markUndoLevel {Name BC}\n' ...
    '$_TMP(PW_1) apply [list [list $_BL(',num2str(ID),') [pw::GridEntity getByName dom-',num2str(numberDomains+6),']]]\n' ...
    'pw::Application markUndoLevel {Set BC}\n' ...
    'set _TMP(PW_2) [pw::BoundaryCondition create]\n' ...
    'pw::Application markUndoLevel {Create BC}\n' ...
    'unset _TMP(PW_2)\n' ...
    'set _TMP(PW_2) [pw::BoundaryCondition getByName bc-3]\n' ...
    '$_TMP(PW_2) setName outlet\n' ...
    '$_TMP(PW_2) setPhysicalType -usage CAE patch\n' ...
    'pw::Application markUndoLevel {Name BC}\n' ...
    '$_TMP(PW_2) apply [list [list $_BL(',num2str(ID),') [pw::GridEntity getByName dom-',num2str(numberDomains+4),']]]\n' ...
    'pw::Application markUndoLevel {Set BC}\n' ...
    'set _TMP(PW_3) [pw::BoundaryCondition create]\n' ...
    'pw::Application markUndoLevel {Create BC}\n' ...
    'unset _TMP(PW_3)\n' ...
    'set _TMP(PW_3) [pw::BoundaryCondition getByName bc-4]\n' ...
    '$_TMP(PW_3) setName upAndDown\n' ...
    '$_TMP(PW_3) setPhysicalType -usage CAE patch\n' ...
    'pw::Application markUndoLevel {Name BC}\n' ...
    '$_TMP(PW_3) apply [list [list $_BL(',num2str(ID),') [pw::GridEntity getByName dom-',num2str(numberDomains+3),']] [list $_BL(',num2str(ID),') [pw::GridEntity getByName dom-',num2str(numberDomains+5),']]]\n' ...
    'pw::Application markUndoLevel {Set BC}\n' ...
    'set _TMP(PW_4) [pw::BoundaryCondition create]\n' ...
    'pw::Application markUndoLevel {Create BC}\n' ...
    'unset _TMP(PW_4)\n' ...
    'set _TMP(PW_4) [pw::BoundaryCondition getByName bc-5]\n' ...
    '$_TMP(PW_4) setName back\n' ...
    '$_TMP(PW_4) setPhysicalType -usage CAE patch\n' ...
    'pw::Application markUndoLevel {Name BC}\n' ...
    '$_TMP(PW_4) apply [list [list $_BL(',num2str(ID),') [pw::GridEntity getByName dom-',num2str(numberDomains+1),']] [list $_BL(',num2str(ID),') [pw::GridEntity getByName dom-',num2str(numberDomains+2),']]]\n' ...
    'pw::Application markUndoLevel {Set BC}\n' ...
    'set _TMP(PW_5) [pw::BoundaryCondition create]\n' ...
    'pw::Application markUndoLevel {Create BC}\n' ...
    'unset _TMP(PW_5)\n' ...
    'set _TMP(PW_5) [pw::BoundaryCondition getByName bc-6]\n' ...
    '$_TMP(PW_5) setName cylinder\n' ...
    '$_TMP(PW_5) setPhysicalType -usage CAE wall\n' ...
    'pw::Application markUndoLevel {Name BC}\n' ...
    string, ...
    'pw::Application markUndoLevel {Set BC}\n' ...
    'unset _TMP(PW_1)\n' ...
    'unset _TMP(PW_2)\n' ...
    'unset _TMP(PW_3)\n' ...
    'unset _TMP(PW_4)\n' ...
    'unset _TMP(PW_5)\n' ...
    'set _TMP(PW_1) [pw::VolumeCondition create]\n' ...
    'pw::Application markUndoLevel {Create VC}\n' ...
    '$_TMP(PW_1) setName Volume\n' ...
    'pw::Application markUndoLevel {Name VC}\n' ...
    '$_TMP(PW_1) apply [list $_BL(',num2str(ID),')]\n' ...
    'pw::Application markUndoLevel {Set VC}\n' ...
    '$_TMP(PW_1) setPhysicalType volumeToCell\n' ...
    'pw::Application markUndoLevel {Change VC Type}\n' ...
    'unset _TMP(PW_1)\n' ...
    '  set _TMP(mode_1) [pw::Application begin CaeExport]\n' ...
    '  $_TMP(mode_1) addAllEntities\n' ...
    '  $_TMP(mode_1) initialize -strict -type CAE ',path,'\n' ...
    '  $_TMP(mode_1) verify\n' ...
    '  $_TMP(mode_1) write\n' ...
    '$_TMP(mode_1) end\n' ...
    'unset _TMP(mode_1)\n']);