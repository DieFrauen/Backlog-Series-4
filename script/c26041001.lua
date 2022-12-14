--Xadres Regent
function c26041001.initial_effect(c)
	--Set this card into S/T zones as a Spell
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MONSTER_SSET)
	e0:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e0)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c26041001.condition)
	e1:SetTarget(c26041001.target)
	e1:SetOperation(c26041001.activate)
	c:RegisterEffect(e1)
	--Destroy
	local e1a=Effect.CreateEffect(c)
	e1a:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e1a:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1a:SetCode(EVENT_LEAVE_FIELD_P)
	e1a:SetOperation(c26041001.checkop)
	c:RegisterEffect(e1a)
	local e1b=Effect.CreateEffect(c)
	e1b:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e1b:SetCode(EVENT_LEAVE_FIELD)
	e1b:SetOperation(c26041001.desop)
	e1b:SetLabelObject(e1a)
	c:RegisterEffect(e1b)
	
end
function c26041001.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_SZONE) and c:IsType(TYPE_SPELL) and c:GetSequence()==2
end
function c26041001.ffilter(c,tp)
	return c:IsCode(26041010) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c26041001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26041001.ffilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c26041001.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	c:CancelToGrave(true)
	local tc=Duel.GetFirstMatchingCard(c26041001.ffilter,tp,LOCATION_DECK,0,nil,tp)
	if Duel.SelectYesNo(tp,aux.Stringid(26041001,1)) and Duel.ActivateFieldSpell(tc,e,tp,eg,ep,ev,re,r,rp) then
		tc:SetCardTarget(c)
	end
end
function c26041001.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsDisabled() then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function c26041001.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():GetLabel()~=0 then return end
	local tc=e:GetHandler():GetFirstCardTarget()
	if tc and tc:IsLocation(LOCATION_FZONE) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end