private _titleStr = localize "STR_A3A_fn_reinf_controlHQSquad_title";

if (player != theBoss) exitWith {[_titleStr, localize "STR_A3A_fn_reinf_controlHQSquad_no_commander"] call A3A_fnc_customHint;};
if (captive player) exitWith {[_titleStr, localize "STR_A3A_fn_reinf_controlHQSquad_no_undercover"] call A3A_fnc_customHint;};
if (!isNil "A3A_FFPun_Jailed" && {(getPlayerUID player) in A3A_FFPun_Jailed}) exitWith {[_titleStr, localize "STR_A3A_fn_reinf_controlHQSquad_no_nope"] call A3A_fnc_customHint;};

_groups = _this select 0;

_groupX = _groups select 0;
_unit = leader _groupX;

if !([_unit] call A3A_fnc_canFight) exitWith {[_titleStr, localize "STR_A3A_fn_reinf_controlHQSquad_no_uncon"] call A3A_fnc_customHint;};

while {(count (waypoints _groupX)) > 0} do
 {
  deleteWaypoint ((waypoints _groupX) select 0);
 };

_wp = _groupX addwaypoint [getpos _unit,0];

{
if (_x != vehicle _x) then
	{
	[_x] orderGetIn true;
	};
} forEach units group player;

hcShowBar false;
hcShowBar true;

_unit setVariable ["owner",player,true];
_eh1 = player addEventHandler ["HandleDamage",
	{
	_unit = _this select 0;
	_unit removeEventHandler ["HandleDamage",_thisEventHandler];
	//removeAllActions _unit;
	selectPlayer _unit;
	(units group player) joinsilent group player;
	group player selectLeader player;
	[_titleStr, localize "STR_A3A_fn_reinf_controlHQSquad_return_damage"] call A3A_fnc_customHint;
	nil;
	}];
_eh2 = _unit addEventHandler ["HandleDamage",
	{
	_unit = _this select 0;
	_unit removeEventHandler ["HandleDamage",_thisEventHandler];
	removeAllActions _unit;
	selectPlayer (_unit getVariable "owner");
	(units group player) joinsilent group player;
	group player selectLeader player;
	[_titleStr, localize "STR_A3A_fn_reinf_controlHQSquad_return_damage_ai"] call A3A_fnc_customHint;
	nil;
	}];
selectPlayer _unit;

_timeX = 180;

_unit addAction [localize "STR_A3A_fn_reinf_controlHQSquad_return",{selectPlayer (player getVariable ["owner",player])}];

waitUntil {sleep 1;[_titleStr, format [localize "STR_A3A_fn_reinf_controlHQSquad_return_time", _timeX]] call A3A_fnc_customHint; _timeX = _timeX - 1; (_timeX < 0) or (isPlayer theBoss)};

removeAllActions _unit;
if (!isPlayer (_unit getVariable ["owner",_unit])) then {selectPlayer (_unit getVariable ["owner",_unit])};
//_unit setVariable ["owner",nil,true];
_unit removeEventHandler ["HandleDamage",_eh2];
player removeEventHandler ["HandleDamage",_eh1];
(units group theBoss) joinsilent group theBoss;
group theBoss selectLeader theBoss;
[_titleStr, ""] call A3A_fnc_customHint;
