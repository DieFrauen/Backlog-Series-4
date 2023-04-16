--Regiamorph Scorpses
function c26044004.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26044004,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c26044004.spcon)
	e1:SetTarget(c26044004.sptg)
	e1:SetOperation(c26044004.spop)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetRange(LOCATION_GRAVE)
	e1a:SetCondition(c26044004.qcon)
	c:RegisterEffect(e1a)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c26044004.limcon)
	e2:SetTarget(c26044004.splimit)
	c:RegisterEffect(e2)
end
function c26044004.qcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,26044012)
end
function c26044004.limcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c26044004.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function c26044004.splimit(e,c)
	return not c:HasLevel()
end
function c26044004.filter(c,tp,tc)
	return c:IsFaceup() and not (
	c:GetOriginalAttribute()==tc:GetOriginalAttribute() and
	c:GetOriginalRace()==tc:GetOriginalRace() and
	c:GetOriginalLevel()==tc:GetOriginalLevel())
end
function c26044004.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c26044004.filter(chkc) and rp~=tp end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c26044004.filter,tp,0,LOCATION_MZONE,1,nil,tp,c) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26044004,1))
	Duel.SelectTarget(tp,c26044004.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp,c)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c26044004.spop(e,tp,eg,ep,ev,re,r,rp)
	local c,tc=e:GetHandler(),Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(c:GetOriginalLevel())
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetValue(c:GetOriginalRace())
		tc:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e3:SetValue(c:GetOriginalAttribute())
		tc:RegisterEffect(e3)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CHANGE_CODE)
		e4:SetValue(26044004)
		tc:RegisterEffect(e4)
	end
end