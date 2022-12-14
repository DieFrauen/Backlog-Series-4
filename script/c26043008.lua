--Fiendish Hetredomix
function c26043008.initial_effect(c)
	--alias
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetValue(CARD_POLYMERIZATION)
	c:RegisterEffect(e1)
	--Fusion summon 1 DARK monster
	local params = {fusfilter=aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),extrafil=c26043008.fextra,extraop=c26043008.extraop,extratg=c26043008.extratarget}
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26043008,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,26043008,EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(Fusion.SummonEffTG(params))
	e2:SetOperation(Fusion.SummonEffOP(params))
	c:RegisterEffect(e2)
	
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
	return mc:ListsCodeAsMaterial(c:GetCode()) or mc:ListsCode(c:GetCode())
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