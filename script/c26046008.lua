--Shatterpoint Space
function c26046008.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--reg
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_TO_GRAVE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetOperation(c26046008.dest)
	c:RegisterEffect(e0)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26046008,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,26046008)
	e2:SetTarget(c26046008.thtg)
	e2:SetOperation(c26046008.thop)
	c:RegisterEffect(e2)
	--tofield
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26046008,2))
	e3:SetCategory(CATEGORY_LEAVE_GRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1,26046008)
	e3:SetLabelObject(e1)
	e3:SetTarget(c26046008.tftg)
	e3:SetOperation(c26046008.tfop)
	c:RegisterEffect(e3)
	--to grave
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26046008,1))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,26046008)
	e4:SetCondition(c26046008.tgcon)
	e4:SetTarget(c26046008.tgtg)
	e4:SetOperation(c26046008.tgop)
	c:RegisterEffect(e4)
end
function c26046008.dest(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if (r&REASON_DESTROY)~=0 then
		c:RegisterFlagEffect(26046108,RESET_CHAIN,0,1)
	end
end
function c26046008.thfilter(c)
	return c:IsSetCard(0x646) and c:IsAbleToHand() and (c:IsLocation(LOCATION_EXTRA) and c:IsPublic() or c:IsLocation(LOCATION_DECK))
end
function c26046008.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c)
		and Duel.IsExistingMatchingCard(c26046008.thfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c26046008.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) and not c:GetFlagEffect(26046108) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
	if #g>0 then Duel.Destroy(g,REASON_EFFECT) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26046008.thfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c26046008.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:GetLabelObject():IsActivatable(tp) and Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c)
		and Duel.IsExistingMatchingCard(c26046008.thfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c26046008.tfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	if #g>0 and e:GetLabelObject():IsActivatable(tp) then
		Duel.Destroy(g,REASON_EFFECT)
		Duel.ActivateFieldSpell(c,e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_CARD,tp,c:GetOriginalCodeRule())
		Duel.HintSelection(Group.FromCards(c))
	end
end
function c26046008.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,26046008)==0
end
function c26046008.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return c end
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,0,0)
end
function c26046008.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) and not c:GetFlagEffect(26046108) then return end
	Duel.Destroy(c,REASON_EFFECT)
	if Duel.GetFlagEffect(tp,26046008)~=0 then return end
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e1:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c26046008.summon)
	Duel.RegisterEffect(e1,tp)
	--activation
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_INACTIVATE)
	e2:SetValue(c26046008.efilter)
	Duel.RegisterEffect(e2,tp)
	Duel.RegisterFlagEffect(tp,26046008,RESET_PHASE+PHASE_END,0,1)
end
function c26046008.summon(e,c)
	return c:IsSummonType(SUMMON_TYPE_PENDULUM) and c:IsSetCard(0x646)
end
function c26046008.efilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	return te:GetHandler():IsSetCard(0x646)
end
