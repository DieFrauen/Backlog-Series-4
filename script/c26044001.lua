--Regiamorphosis Queen
function c26044001.initial_effect(c)
	--summon with infected opposing monster
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(c26044001.tribute)
	e1:SetValue(POS_FACEUP)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26044001,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(c26044001.sptg)
	e2:SetOperation(c26044001.spop)
	e2:SetCountLimit(1,26044001,EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e2)
	local e2a=e2:Clone()
	e2a:SetRange(LOCATION_GRAVE)
	e2a:SetCondition(c26044001.qcon)
	c:RegisterEffect(e2a)
	--synchro effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26044001,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(TIMINGS_CHECK_MONSTER+TIMING_MAIN_END,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c26044001.syncon)
	e3:SetTarget(c26044001.synctg)
	e3:SetOperation(c26044001.syncop)
	c:RegisterEffect(e3)
end
function c26044001.tribute(e,c)
	return c:GetCounter(0x1045)==1
end
function c26044001.qcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,26044012)
end
function c26044001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1045,8,REASON_EFFECT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end
function c26044001.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1045,8,REASON_EFFECT) then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		for tc in g:Iter() do
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_REMOVE_COUNTER+0x1045)
			e3:SetRange(LOCATION_MZONE)
			e3:SetCondition(c26044001.ctcon)
			e3:SetOperation(c26044001.ctop)
			e3:SetReset(RESET_CHAIN)
			tc:RegisterEffect(e3)
		end
		Duel.RemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1045,8,REASON_COST)
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c26044001.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x1045)==0
end
function c26044001.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL_FINAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_ATTACK_FINAL)
	e2:SetValue(0)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e3:SetValue(0)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DISABLE_EFFECT)
	e5:SetValue(RESET_TURN_SET)
	e5:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e5)
end

function c26044001.syncon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c26044001.synctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) and c:GetFlagEffect(26044001)==0 end
	c:RegisterFlagEffect(26044001,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c26044001.syncop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsControler(1-tp) or not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,c)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),c)
	end
end