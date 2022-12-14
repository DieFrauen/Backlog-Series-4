--Hetredo Fusion
function c26043009.initial_effect(c)
	local e1=Fusion.CreateSummonEff(c,nil,c26043009.matfilter,c26043009.fextra,Fusion.BanishMaterial,nil,nil,nil,nil,nil,nil,nil,nil,nil,c26043009.extratg)
	c:RegisterEffect(e1)
	--code
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CHANGE_CODE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e0:SetValue(CARD_POLYMERIZATION)
	c:RegisterEffect(e0)
	
end
c26043009.listed_series={0x643}
function c26043009.matfilter(c)
	return (c:IsLocation(LOCATION_HAND) or c:IsOnField()) and c:IsAbleToRemove()
end
function c26043009.cond1(e,tp,mg)
	return not Duel.IsPlayerAffectedByEffect(tp,69832741) and Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_MZONE,1,nil,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)
end
function c26043009.cond2(e,tp)
	return Duel.IsExistingMatchingCard(c26043009.otfilter,tp,0,LOCATION_MZONE,1,nil,tp)
end
function c26043009.otfilter(c,tp)
	local mg=c:GetMaterial()
	local ov=c:GetOverlayGroup()
	mg:Merge(ov)
	return c:IsFaceup() and c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)
	and not mg:IsExists(c26043009.code,1,nil,c)
end
function c26043009.code(c,mc)
	return mc:ListsCodeAsMaterial(c:GetCode()) or mc:ListsCode(c:GetCode()) and c:IsLocation(LOCATION_GRAVE+LOCATION_OVERLAY)
end
function c26043009.fcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1 and sg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)<=1 and fc:IsSetCard(0x643)
end
function c26043009.fextra(e,tp,mg)
	local g=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsAbleToRemove),tp,LOCATION_GRAVE,0,nil)
	if c26043009.cond1(e,tp,mg) then g:Merge(g1) end
	local g2=Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsAbleToRemove),tp,LOCATION_DECK,0,nil)
	if c26043009.cond2(e,tp) then g:Merge(g2) end
	return g,c26043009.fcheck
end
function c26043009.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end