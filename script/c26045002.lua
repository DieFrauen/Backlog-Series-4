--Planetheon Sage - Uraunus
function c26045002.initial_effect(c)
	Xyz.AddProcedure(c,nil,8,8)
	c:EnableReviveLimit()
	--cannot Xyz material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	--Attach battled monster as material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26045002,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetTarget(c26045002.target)
	e1:SetOperation(c26045002.operation)
	c:RegisterEffect(e1)
	--negate hand effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26045002,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c26045002.distg)
	e2:SetOperation(c26045002.disop)
	c:RegisterEffect(e2)
	--activate Planetheon Horizon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26045001,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c26045002.fcon)
	e3:SetTarget(c26045002.ftg)
	e3:SetOperation(c26045002.fop)
	c:RegisterEffect(e3)
end
function c26045002.filter(c,e)
	return not c:IsImmuneToEffect(e)
end
function c26045002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	local hg=Duel.GetMatchingGroup(c26045002.filter,tp,0,LOCATION_HAND,nil,e)
	if chk==0 then return tc and c:IsType(TYPE_XYZ) and #hg>0 and not tc:IsType(TYPE_TOKEN) and tc:IsAbleToChangeControler() end
end
function c26045002.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	local hg=Duel.GetMatchingGroup(c26045002.filter,tp,0,LOCATION_HAND,nil,e)
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToBattle() and not tc:IsImmuneToEffect(e) and #hg>0 then
		local sg=hg:RandomSelect(tp,1)
		sg:AddCard(tc)
		Duel.Overlay(c,sg,true)
	end
end
function c26045002.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c26045002.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(0,1)
		e1:SetValue(c26045002.aclimit)
		e1:SetLabel(tc:GetCode())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c26045002.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsCode(e:GetLabel())
end
function c26045002.fcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousSequence()>=5
end
function c26045002.ffilter(c,tp)
	return c:IsCode(26045007) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c26045002.ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26045002.ffilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
end
function c26045002.fop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26045002.ffilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc then
		Duel.ActivateFieldSpell(tc,e,tp,eg,ep,ev,re,r,rp)
	end
end