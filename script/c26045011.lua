--Planetheon Disgorge
function c26045011.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26045011,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetTarget(c26045011.thtg)
	e2:SetOperation(c26045011.thop)
	c:RegisterEffect(e2)
	--handes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26045011,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c26045011.hdcon)
	e3:SetTarget(c26045011.hdtg)
	e3:SetOperation(c26045011.hdop)
	c:RegisterEffect(e3)
end
function c26045011.cfilter(c,tp)
	return not c:IsReason(REASON_DRAW)
end
function c26045011.ura(c)
	return c:IsFaceup() and c:IsCode(26045002,26045007)
end
function c26045011.hdcon(e,tp,eg,ep,ev,re,r,rp)
	local ura=Duel.IsExistingMatchingCard(c26045011.ura,tp,LOCATION_ONFIELD,0,1,nil)
	return eg:IsExists(c26045011.cfilter,1,nil,1-tp) and ura  
end
function c26045011.xyzfilter(c,mat)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetOverlayCount()>1 and c:GetSequence()>=5
end
function c26045011.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return
		Duel.IsExistingMatchingCard(c26045011.xyzfilter,tp,LOCATION_MZONE,0,1,nil) 
		and Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_HAND,1,nil)
		and c:GetFlagEffect(26045011)==0 end
	local tg=Duel.SelectTarget(tp,c26045011.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.HintSelection(tg)
	c:RegisterFlagEffect(26045011,RESET_CHAIN,0,1)
end
function c26045011.hdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g1=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(nil,tp,0,LOCATION_HAND,nil)
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) or not tc:IsType(TYPE_XYZ) or not (#g1>0 and #g2>0) then return end
	local g=tc:GetOverlayGroup():Select(tp,2,2,nil)
	if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		local sg1=g1:RandomSelect(tp,1)
		local sg2=g2:RandomSelect(tp,1)
		sg1:Merge(sg2)
		Duel.Overlay(tc,sg1)
	end
end
function c26045011.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_SZONE)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_EFFECT) and ct>0 end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,0,0,0)
end
function c26045011.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ct=Duel.GetFieldGroup(tp,0,LOCATION_SZONE)
	Duel.RemoveOverlayCard(tp,1,0,1,#ct,REASON_EFFECT)
	local ov=#Duel.GetOperatedGroup()
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(1-tp,nil,1-tp,LOCATION_ONFIELD,0,ov,ov,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end