--Shatternal Attack
function c26046009.initial_effect(c)
	-- Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e1:SetCountLimit(1,26046009,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c26046009.descon)
	e1:SetTarget(c26046009.destg)
	e1:SetOperation(c26046009.desop)
	c:RegisterEffect(e1)
end
function c26046009.cfilter(c)
	return c:IsFacedown()
end
function c26046009.descon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c26046009.cfilter,tp,LOCATION_EXTRA,0,1,nil)
end
function c26046009.desfilter(c,e,tp)
	return c:IsControler(tp) and c:IsFaceup() and c:IsSetCard(0x646)
end
function c26046009.desrescon(sg,e,tp,mg)
	return sg:FilterCount(c26046009.desfilter,nil,e,tp)>0
end
function c26046009.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(Card.IsCanBeEffectTarget,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler(),e)
	if chk==0 then return aux.SelectUnselectGroup(g,e,tp,3,3,c26046009.desrescon,0) end
	local dg=aux.SelectUnselectGroup(g,e,tp,3,3,c26046009.desrescon,1,tp,HINTMSG_DESTROY)
	Duel.SetTargetCard(dg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,#dg,0,0)
end
function c26046009.desop(e,tp,eg,ep,ev,re,r,rp)
	local shatter=(Duel.IsPlayerAffectedByEffect(tp,26046000) or Duel.IsPlayerAffectedByEffect(tp,26046001))
	local sg=Duel.GetTargetCards(e)
	if #sg>0 then
		if shatter then
			c26046001.shatter(e,tp,sg,true,REASON_EFFECT,nil)
		else 
			Duel.Destroy(sg,REASON_EFFECT)
		end
	end
end