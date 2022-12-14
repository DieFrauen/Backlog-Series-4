--Hetredo Enmity
function c26043011.initial_effect(c)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26043011,0))
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCondition(c26043011.condition1)
	e1:SetTarget(c26043011.target1)
	e1:SetOperation(c26043011.activate1)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26043011,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c26043011.condition2)
	e2:SetTarget(c26043011.target2)
	e2:SetOperation(c26043011.activate2)
	c:RegisterEffect(e2)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(c26043011.handcon)
	c:RegisterEffect(e3)
	
end
function c26043011.handcon(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c26043011.matfilter,tp,LOCATION_MZONE,0,1,nil,2)
end
function c26043011.matfilter(c,num)
	return c:IsFaceup()
	and c:IsSummonType(SUMMON_TYPE_FUSION)
	and c:GetMaterial() and c:GetMaterial():Filter(c26043011.code,nil,c):GetClassCount(Card.GetCode)>=num 
end
function c26043011.code(c,tc)
	return c:IsCode(table.unpack(tc.material))
end
function c26043011.filter(c)
	return c:GetSummonLocation()&LOCATION_EXTRA~=0 and c:IsAbleToRemove()
end
function c26043011.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain(true)==0 and eg:IsExists(c26043011.filter,1,nil) and Duel.IsExistingMatchingCard(c26043011.matfilter,tp,LOCATION_MZONE,0,1,nil,1)
end
function c26043011.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(c26043011.filter,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end
function c26043011.activate1(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.filter,nil)
	Duel.NegateSummon(g)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if c:IsSSetable(true) and e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsExistingMatchingCard(c26043011.matfilter,tp,LOCATION_MZONE,0,1,nil,3) then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
function c26043011.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c26043011.matfilter,tp,LOCATION_MZONE,0,1,nil,1)
		and Duel.IsChainNegatable(ev)
end
function c26043011.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c26043011.activate2(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		ec:CancelToGrave()
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if c:IsSSetable(true) and e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsExistingMatchingCard(c26043011.matfilter,tp,LOCATION_MZONE,0,1,nil,3) then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end