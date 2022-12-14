--Transhatternal
function c26046012.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c26046012.handcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26046012,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c26046012.target)
	c:RegisterEffect(e1)
	local e1a=Effect.CreateEffect(c)
	e1a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1a:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1a:SetRange(LOCATION_SZONE)
	e1a:SetCode(EVENT_CHAIN_SOLVED)
	e1a:SetLabelObject(e1)
	e1a:SetCondition(Auxiliary.PersistentTgCon)
	e1a:SetOperation(Auxiliary.PersistentTgOp(anypos))
	c:RegisterEffect(e1a)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_LEAVE_FIELD_P)
	e2:SetOperation(c26046012.checkop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetOperation(c26046012.desop)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--Destroy2
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c26046012.descon2)
	e4:SetOperation(c26046012.desop2)
	c:RegisterEffect(e4)
	--destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTarget(c26046012.desrtg)
	e5:SetValue(c26046012.value)
	e5:SetOperation(c26046012.desrop)
	c:RegisterEffect(e5)
	--activate effect from graveyard
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(26046012,1))
	e6:SetCategory(CATEGORY_DISABLE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetCondition(aux.exccon)
	e6:SetCost(aux.bfgcost)
	e6:SetTarget(c26046012.dgtg)
	e6:SetOperation(c26046012.dgop)
	c:RegisterEffect(e6)
	
end
function c26046012.handcon(e)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,nil,0x646)
end
function c26046012.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:GetLocation()==LOCATION_ONFIELD end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
end
function c26046012.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		c:RegisterFlagEffect(26046012,RESET_EVENT+RESETS_STANDARD,0,1,tp)
	end
end
function c26046012.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsDisabled() then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function c26046012.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():GetLabel()~=0 then return end
	local tc=e:GetHandler():GetFirstCardTarget()
	if tc and e:GetHandler():IsReason(REASON_DESTROY) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c26046012.descon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc and eg:IsContains(tc)
end
function c26046012.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
function c26046012.drfilter(c)
	return c:IsSetCard(0x646)
	and c:IsFaceup()
	and c:IsDestructable()
	and not c:IsReason(REASON_REPLACE)
end
function c26046012.desrtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=c:GetFirstCardTarget()
	if chk==0 then return eg:FilterCount(c26046012.drfilter,1,tc)>0 and tc and not tc:IsStatus(STATUS_DESTROY_CONFIRMED) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		return true
	else return false end
end
function c26046012.value(e,c)
	return c:IsFaceup() and c:IsSetCard(0x646) and c:IsControler(e:GetHandlerPlayer())
end
function c26046012.desrop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	Duel.HintSelection(Group.FromCards(tc))
	if tc then Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE) end
end
function c26046012.dfilter(c)
	return c:IsSetCard(0x646) and c:IsFaceup()
end
function c26046012.dgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g1=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(c26046012.dfilter,tp,LOCATION_EXTRA,0,nil)
	g1:Merge(g2)
	if chk==0 then return #g1>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
end
function c26046012.dgop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(c26046012.dfilter,tp,LOCATION_EXTRA,0,nil)
	g1:Merge(g2)
	local tc=g1:Select(tp,1,1,nil)
	if tc then
		if Duel.IsPlayerAffectedByEffect(tp,26046000) or Duel.IsPlayerAffectedByEffect(tp,26046001) then
			c26046001.shatter(e,tp,tc,true,REASON_EFFECT,nil)
		else 
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end

