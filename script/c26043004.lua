--Hetredox Warlord
function c26043004.initial_effect(c)
	--Fusion Material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,false,false,26043001,26043002)
	--Negate Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26043004,0))
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c26043004.condition)
	e1:SetCost(c26043004.cost)
	e1:SetTarget(c26043004.target)
	e1:SetOperation(c26043004.operation)
	c:RegisterEffect(e1)
	--Other monsters you control gain 500 ATK during your turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(function(e,c) return c:GetSummonType()&SUMMON_TYPE_FUSION ~=0 end)
	e2:SetValue(c26043004.atval)
	c:RegisterEffect(e2)
end
function c26043004.atval(e,c)
	local mat=c:GetMaterial()
	local mf=mat:Filter(c26043004.code,nil,c):GetClassCount(Card.GetCode)
	return mf*400
end
function c26043004.filter(c)
	local mat=c:GetMaterial()
	return c:GetSummonType()&SUMMON_TYPE_FUSION+SUMMON_TYPE_SYNCHRO+SUMMON_TYPE_XYZ+SUMMON_TYPE_LINK ~=0 and c:IsAbleToRemove() and not mat:IsExists(c26043004.code,1,nil,c)
end
function c26043004.code(c,rc)
	return rc:ListsCodeAsMaterial(c:GetCode())
end
function c26043004.poly(c)
	return c:IsCode(CARD_POLYMERIZATION) and c:IsDiscardable()
end
function c26043004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	e:SetLabel(0)
	local g1=eg:Filter(c26043004.filter,nil)
	local g2=eg:Clone()
	g2:Sub(g1)
	local g3=Duel.GetMatchingGroup(c26043004.poly,tp,LOCATION_HAND,0,nil)
	if chk==0 then return #g1>0 or (#g2>0 and #g3>0) end 
	if #g2>0 and (#g3>0 and #g1==0 or Duel.SelectYesNo(tp,aux.Stringid(26043004,1))) then
		Duel.DiscardHand(tp,c26043004.poly,1,1,REASON_COST+REASON_DISCARD)
		e:SetLabel(1)
	end
end
function c26043004.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain(true)==0 and eg:IsExists(c26043004.filter,1,nil)
end
function c26043004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg
	if e:GetLabel()==0 then g=eg:Filter(c26043004.filter,nil) end
	local g=eg:Filter(c26043004.filter,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end
function c26043004.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=eg
	if e:GetLabel()==0 then g=eg:Filter(c26043004.filter,nil) end
	Duel.NegateSummon(g)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end