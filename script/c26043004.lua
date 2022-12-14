--Hetredox Warmaster
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
	e1:SetCondition(c26043004.condition)
	e1:SetCost(c26043004.cost)
	e1:SetTarget(c26043004.target)
	e1:SetOperation(c26043004.operation)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26043004,2))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c26043004.thtg)
	e2:SetOperation(c26043004.thop)
	c:RegisterEffect(e2)
	
end
function c26043004.filter(c)
	local mat=c:GetMaterial()
	return c:GetSummonType()&SUMMON_TYPE_FUSION+SUMMON_TYPE_SYNCHRO+SUMMON_TYPE_XYZ+SUMMON_TYPE_LINK ~=0 and c:IsAbleToRemove() and not mat:IsExists(c26043004.code,1,nil,c)
end
function c26043004.code(c,rc)
	return (rc:ListsCodeAsMaterial(c:GetCode()) or rc:ListsCode(c:GetCode()))
end
function c26043004.cfilter(c)
	return c:IsCode(CARD_POLYMERIZATION) and c:IsDiscardable()
end
function c26043004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(26043004)==0 or Duel.IsExistingMatchingCard(c26043004.cfilter,tp,LOCATION_HAND,0,1,nil) end
	if c:GetFlagEffect(26043004)==0 then
		c:RegisterFlagEffect(26043004,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,0)
	else
		Duel.DiscardHand(tp,c26043004.cfilter,1,1,REASON_COST+REASON_DISCARD)
	end
end
function c26043004.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain(true)==0 and eg:IsExists(c26043004.filter,1,nil)
end
function c26043004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(c26043004.filter,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end
function c26043004.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c26043004.filter,nil)
	Duel.NegateSummon(g)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end
function c26043004.thfilter(c,tc)
	return c:IsCode(table.unpack(tc.material)) and c:IsAbleToHand()
end
function c26043004.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and s.thfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c26043004.thfilter,tp,LOCATION_REMOVED,0,1,nil,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c26043004.thfilter,tp,LOCATION_REMOVED,0,1,2,nil,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
end
function c26043004.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #sg>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end

