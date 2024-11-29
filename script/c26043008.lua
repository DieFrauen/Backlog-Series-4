--Fiendish Hetredomix
function c26043008.initial_effect(c)
	--alias
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_ONFIELD+LOCATION_HAND)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetValue(CARD_POLYMERIZATION)
	c:RegisterEffect(e1)
	--Fusion summon
	local params = {fusfilter=aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),extrafil=c26043008.fextra,extraop=c26043008.extraop,extratg=c26043008.extratarget}
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26043008,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,26043008)
	e2:SetTarget(Fusion.SummonEffTG(params))
	e2:SetOperation(Fusion.SummonEffOP(params))
	c:RegisterEffect(e2)
	--search 2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26043008,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE|LOCATION_HAND)
	e3:SetCountLimit(1,26043008)
	e3:SetCondition(c26043008.condition)
	e3:SetCost(c26043008.cost)
	e3:SetTarget(c26043008.target)
	e3:SetOperation(c26043008.activate)
	c:RegisterEffect(e3)
	
end
function c26043008.fextra(e,tp,mg)
	if not Duel.IsPlayerAffectedByEffect(tp,69832741) then
		return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsAbleToRemove),tp,LOCATION_GRAVE,0,nil),c26043008.checkmat
	end
	return nil,c26043008.checkmat
end
function c26043008.checkmat(tp,sg,fc)
	return sg:IsExists(c26043008.code,1,nil,fc)
end
function c26043008.code(c,mc)
	return mc:ListsCodeAsMaterial(c:GetCode())
end
function c26043008.extraop(e,tc,tp,sg)
	local rg=sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	if #rg>0 then
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		sg:Sub(rg)
	end
end
function c26043008.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_GRAVE)
end
function c26043008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c26043008.filter1(c)
	return c:IsCode(CARD_POLYMERIZATION) and c:IsAbleToHand()
end
function c26043008.filter2(c)
	return c:IsSetCard(0x643) and c:IsMonster() and c:IsAbleToHand()
end
function c26043008.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c26043008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26043008.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(c26043008.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c26043008.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c26043008.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	local g2=Duel.GetMatchingGroup(c26043008.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if #g1>0 and #g2>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg1)
	end
end
