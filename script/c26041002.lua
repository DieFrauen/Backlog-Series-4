--Xadres War Mistress
function c26041002.initial_effect(c)
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
	e1:SetCondition(c26041002.condition)
	e1:SetOperation(c26041002.activate)
	c:RegisterEffect(e1)
	
end
function c26041002.king(c)
	return c:IsFaceup() and c:IsCode(26041001)
end
function c26041002.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetType()&TYPE_SPELL+TYPE_CONTINUOUS ==TYPE_SPELL+TYPE_CONTINUOUS and Duel.IsExistingMatchingCard(c26041002.king,tp,LOCATION_ONFIELD,0,1,nil)
end
function c26041002.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	c:CancelToGrave(true)
end