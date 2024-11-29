--Hetredox Warhound
function c26043005.initial_effect(c)
	--Fusion Material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,false,false,26043001,26043003)
	--Negate activation
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26043005,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c26043005.negcon)
	e1:SetCost(c26043005.negcost)
	e1:SetTarget(c26043005.negtg)
	e1:SetOperation(c26043005.negop)
	c:RegisterEffect(e1)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c26043005.piercetg)
	c:RegisterEffect(e2)
	--double pierce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetCondition(c26043005.damcon)
	e3:SetOperation(c26043005.damop)
	c:RegisterEffect(e3)
end
function c26043005.piercetg(e,c)
	return c:IsType(TYPE_FUSION)
end
function c26043005.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and re:GetHandler()~=c
end
function c26043005.filter1(c)
	return c:IsCode(CARD_POLYMERIZATION) and c:IsDiscardable()
end
function c26043005.filter2(c,rc)
	local mat=rc:GetMaterial()
	return mat and rc:GetSummonType()&SUMMON_TYPE_FUSION+SUMMON_TYPE_SYNCHRO+SUMMON_TYPE_XYZ+SUMMON_TYPE_LINK ~=0 and c:IsAbleToRemove() and mat:IsContains(c) and not (rc:ListsCodeAsMaterial(c:GetCode()) or rc:ListsCode(c:GetCode()))
end
function c26043005.filter3(c,mc)
	return not mc:ListsCodeAsMaterial(c:GetCode())
end
function c26043005.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local g1=Duel.GetMatchingGroup(c26043005.filter1,tp,LOCATION_HAND,0,nil) 
	local g2=Duel.GetMatchingGroup(c26043005.filter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,rc)
	local g3=rc:GetOverlayGroup():Filter(c26043005.filter3,nil,rc)
	g2:Merge(g3)
	if chk==0 then return #g1>0 or #g2>0 end
	g1:Merge(g2)
	local sg=g1:Select(tp,1,1,nil):GetFirst()
	if sg:GetLocation()==LOCATION_HAND then
		Duel.SendtoGrave(sg,REASON_COST+REASON_DISCARD)
	else
		Duel.Remove(sg,POS_FACEUP,REASON_COST)
	end
end
function c26043005.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	local relation=rc:IsRelateToEffect(re)
	if chk==0 then return rc:IsAbleToRemove(tp)
		or (not relation and Duel.IsPlayerCanRemove(tp)) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if relation then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,rc,1,rc:GetControler(),rc:GetLocation())
	else
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,0,rc:GetPreviousLocation())
	end
end
function c26043005.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
	end
end
function c26043005.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac,dc=Duel.GetAttacker(),Duel.GetAttackTarget()
	local mat=ac:GetMaterial()
	local mf=mat:Filter(c26043005.filter3,nil,ac)
	mat:Sub(mf)
	return dc and ac:IsType(TYPE_FUSION) and mat:GetClassCount(Card.GetCode)>1 and ep==dc:GetControler() and dc:IsDefensePos()
end
function c26043005.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end