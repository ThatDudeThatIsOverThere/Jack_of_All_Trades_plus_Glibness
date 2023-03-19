--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

function onInit()
	--Initial setup to provide compatibility with new and existing skillroll/checkroll/initroll functions.
	onSkillRoll = ActionSkill.onRoll;
	ActionSkill.onRoll = newonSkillRoll;
	ActionsManager.registerResultHandler("skill", ActionSkill.onRoll);
	onCheckRoll = ActionCheck.onRoll;
	ActionCheck.onRoll = newonCheckRoll;
	ActionsManager.registerResultHandler("check", ActionCheck.onRoll);
	onInitRoll = ActionInit.onResolve;
	ActionInit.onResolve = newonInitRoll;
	ActionsManager.registerResultHandler("init", ActionInit.onResolve);
	DataSpell.parsedata ["glibness"] = {
		{ type = "effect", sName = "Glibness", sTargeting = "self", nDuration = 1, sUnits = "hour" },
	};
end

function newonSkillRoll(rSource, rTarget, rRoll)
	if checkGlib(rSource, rRoll) then
		applyGlib(rRoll)
	end
	if checkRemark(rSource, rRoll) then
		applyHalf(rSource, rRoll, true, "Remarkable Athlete")
	elseif checkJack(rSource, rRoll) then
		applyHalf(rSource, rRoll, false, "Jack of All Trades")
	end
	onSkillRoll(rSource, rTarget, rRoll)
end

function newonCheckRoll(rSource, rTarget, rRoll)
	if checkGlib(rSource, rRoll) then
		applyGlib(rRoll)
	end
	if checkRemark(rSource, rRoll) then
		applyHalf(rSource, rRoll, true, "Remarkable Athlete")
	elseif checkJack(rSource, rRoll) then
		applyHalf(rSource, rRoll, false, "Jack of All Trades")
	end
	onCheckRoll(rSource, rTarget, rRoll)
end

function newonInitRoll(rSource, rTarget, rRoll)
	if checkRemark(rSource, rRoll) then
		applyHalf(rSource, rRoll, true, "Remarkable Athlete")
	elseif checkJack(rSource, rRoll) then
		applyHalf(rSource, rRoll, false, "Jack of All Trades")
	end
	onInitRoll(rSource, rTarget, rRoll)
end

function checkJack(rSource,rRoll)
	local sPCNodeName = ActorManager.getCreatureNodeName(rSource);
	local nodeFeatureList = DB.getChild(sPCNodeName, "featurelist");
	if nodeFeatureList and
	not string.match(rRoll.sDesc,"%[PROF%]") and not string.match(rRoll.sDesc,"%[PROF x2%]") and not string.match(rRoll.sDesc,"%[PROF x1/2%]") then
	for k, nodeFeature in pairs (nodeFeatureList.getChildren()) do
		if DB.getValue(nodeFeature, "name", ""):lower() == "jack of all trades" then
			return true
		end
	end
	end
	return false
end

function checkRemark(rSource,rRoll)
	local sPCNodeName = ActorManager.getCreatureNodeName(rSource);
	local nodeFeatureList = DB.getChild(sPCNodeName, "featurelist");
	local bRemark = false;
	if nodeFeatureList and 
	not string.match(rRoll.sDesc,"%[PROF%]") and not string.match(rRoll.sDesc,"%[PROF x2%]") and not string.match(rRoll.sDesc,"%[PROF x1/2%]") then
		for k, nodeFeature in pairs (nodeFeatureList.getChildren()) do
			if DB.getValue(nodeFeature, "name", ""):lower() == "remarkable athlete" then
				bRemark = true;
			end
		end
		if bRemark then
			local sInit = rRoll.sDesc:match("%[INIT%]");
			if sInit then
				return true;
			end
			local sAbility = rRoll.sDesc:match("%[CHECK%] (%w+)");
			if not sAbility then
				local sSkill = rRoll.sDesc:match("%[SKILL%] (%w+)");
				if sSkill == "Sleight" then
					sSkill = "Sleight of Hand";
				end
				if sSkill then
					sAbility = rRoll.sDesc:match("%[MOD:(%w+)%]");
					if sAbility then
						sAbility = DataCommon.ability_stol[sAbility];
					else
						for k, v in pairs(DataCommon.skilldata) do
							if k == sSkill then
								sAbility = v.stat;
							end
						end
					end
				end
			end
			if sAbility then
				sAbility = sAbility:lower();
			end
			if ((sAbility == "strength") or (sAbility == "dexterity") or (sAbility == "constitution")) then
				return true
			end
		end
	end
	return false
end

function checkGlib(rSource,rRoll)
	if EffectManager5E.hasEffectCondition(rSource, "Glibness") then
		local sAbility = rRoll.sDesc:match("%[CHECK%] (%w+)");
		if not sAbility then
			local sSkill = rRoll.sDesc:match("%[SKILL%] (%w+)");
			if sSkill then
				sAbility = rRoll.sDesc:match("%[MOD:(%w+)%]");
				if sAbility then
					sAbility = DataCommon.ability_stol[sAbility];
				else
					for k, v in pairs(DataCommon.skilldata) do
						if k == sSkill then
							sAbility = v.stat;
						end
					end
				end
			end
		end
		if sAbility then
			sAbility = sAbility:lower();
		end
		if sAbility == "charisma" then
			return true
		end
	end
	return false
end

function applyGlib(rRoll)
	local glibused=false
	local newString=""
	for k, die in ipairs(rRoll.aDice) do
		if die.result < 15 and die.type=="d20" and glibused==false then
			newString=rRoll.aDice[k].result
			die.result = 15;
			die.value = 15;
			glibused=true
		end
		if die.result < 15 and die.type=="d20" and glibused==true then
			newString=newString..", "..rRoll.aDice[k].result
			die.result = 15;
			die.value = 15;
		end
	end
	if glibused then
	rRoll.sDesc="Glibness\r".."[DROPPED "..newString.."]\r"..rRoll.sDesc
	end
end

function applyHalf(rSource, rRoll, bRoundCheck, sText)
	local sPCNodeName = ActorManager.getCreatureNodeName(rSource);
	local profNode = DB.getChild(sPCNodeName, "profbonus");
	local prof = 0;
	if profNode then
		prof = profNode.getValue();
	end
	local sMessage = "Half Proficiency";
	if sText then
		sMessage = sText;
	end
	local halfProf = 0;
	if bRoundCheck then
		halfProf = math.ceil(prof / 2);
		
	else
		halfProf = math.floor(prof / 2);
	end
	rRoll.nMod = rRoll.nMod + halfProf;
	rRoll.sDesc = rRoll.sDesc .. " [" .. sMessage .. " +" .. halfProf .. "]"
end