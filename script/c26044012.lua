--Regiamorphosis
function c26044012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c26044012.target)
	e1:SetOperation(c26044012.activate)
	c:RegisterEffect(e1)
end

function c26044012.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,26044012) or Duel.IsExistingMatchingCard(c26044012.ctfilter,tp,0,LOCATION_MZONE,1,nil) end
end
function c26044012.ctfilter(c)
	return c:GetCounter(0x1045)>0 and c:GetFlagEffect(26044012)==0
end
function c26044012.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=Duel.GetMatchingGroup(c26044012.ctfilter,tp,0,LOCATION_MZONE,nil)
	local ct1=(not Duel.IsPlayerAffectedByEffect(tp,26044012))
	local ct2=#cg>0
	if not (ct1 or ct2) then return end
	local ct3=(ct1 and ct2 and Duel.GetCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1045)>9)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26044012,0))
	local opt=Duel.SelectEffect(tp,
		{ct1,aux.Stringid(26044012,1)},
		{ct2,aux.Stringid(26044012,2)},
		{ct3,aux.Stringid(26044012,3)})
	if opt~=2 then
		--become quick
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(26044012,4))
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_OATH)
		e2:SetCode(26044012)
		e2:SetTargetRange(1,0)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
	if opt~=1 then
		for tc in aux.Next(cg) do
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(26044012,5))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SYNCHRO_MATERIAL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetCondition(c26044012.ctcond)
			tc:RegisterEffect(e1)
			--lv change
			local e2=e1:Clone()
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_OATH)
			e2:SetCode(EFFECT_SYNCHRO_LEVEL)
			e2:SetValue(c26044012.lvval)
			tc:RegisterEffect(e2)
		end
	end
end

function c26044012.ctcond(e)
	return e:GetHandler():GetCounter(0x1045)>0
end
function c26044012.lvval(e,c,rc)
	local lv=e:GetHandler():GetLevel()
	local ct=c:GetCounter(0x1045)
	return ct*65536+lv
end