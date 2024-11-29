--Hetredo Enmity
function c26043011.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26043011,1))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c26043011.condition)
	e1:SetTarget(c26043011.target)
	e1:SetOperation(c26043011.activate)
	c:RegisterEffect(e1)
end
function c26043011.matfilter(c,num)
	local mat=c:GetMaterial()
	local mtt=mat:Filter(c26043011.code,nil,c):GetClassCount(Card.GetCode)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_FUSION)
	and mat
	and #mat==mtt
	and mtt>=num
end
function c26043011.code(c,tc)
	return c:IsCode(table.unpack(tc.material))
end
function c26043011.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c26043011.matfilter,tp,LOCATION_MZONE,0,1,nil,2)
		and Duel.IsChainNegatable(ev)
end
function c26043011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c26043011.activate(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	if not Duel.IsExistingMatchingCard(c26043011.matfilter,tp,LOCATION_MZONE,0,1,nil,2) then return end
	if Duel.NegateActivation(ev) and ec:IsRelateToEffect(re) then
		Duel.Remove(ec,POS_FACEUP,REASON_EFFECT)
		local c=e:GetHandler()
		if not (c:IsRelateToEffect(e) and c:IsSSetable(true) and e:IsHasType(EFFECT_TYPE_ACTIVATE)) then return end
		if ec:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK) or Duel.IsExistingMatchingCard(c26043011.matfilter,tp,LOCATION_MZONE,0,1,nil,3) then
			Duel.BreakEffect()
			c:CancelToGrave()
			Duel.ChangePosition(c,POS_FACEDOWN)
			Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		end
	end
end