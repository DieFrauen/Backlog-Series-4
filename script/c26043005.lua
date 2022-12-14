--Hetredox Warmonger
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

	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26043004,2))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c26043005.thtg)
	e2:SetOperation(c26043005.thop)
	c:RegisterEffect(e2)
	
end
function c26043005.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c26043005.filter1(c)
	return c:IsCode(CARD_POLYMERIZATION) and c:IsDiscardable()
end
function c26043005.filter2(c,rc)
	local mat=rc:GetMaterial()
	return mat and rc:GetSummonType()&SUMMON_TYPE_FUSION+SUMMON_TYPE_SYNCHRO+SUMMON_TYPE_XYZ+SUMMON_TYPE_LINK ~=0 and c:IsAbleToRemove() and mat:IsContains(c) and not (rc:ListsCodeAsMaterial(c:GetCode()) or rc:ListsCode(c:GetCode()))
end
function c26043005.filter3(c,mc)
	return not (mc:ListsCodeAsMaterial(c:GetCode()) or mc:ListsCode(c:GetCode()))
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
	if sg:GetLocation()==LOCATION_GRAVE then
		Duel.Remove(sg,POS_FACEUP,REASON_COST)
	elseif sg:GetLocation()==LOCATION_HAND then
		Duel.SendtoGrave(sg,REASON_COST+REASON_DISCARD)
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
		Duel.Remove(rc,POS_FACEDOWN,REASON_EFFECT)
	end
end
function c26043005.thfilter(c,tc)
	return c:IsCode(table.unpack(tc.material)) and c:IsAbleToHand()
end
function c26043005.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and s.thfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c26043005.thfilter,tp,LOCATION_REMOVED,0,1,nil,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c26043005.thfilter,tp,LOCATION_REMOVED,0,1,2,nil,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
end
function c26043005.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #sg>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end

