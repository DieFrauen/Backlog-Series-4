--Planetheon Lord - Neptunus
function c26045001.initial_effect(c)
	Xyz.AddProcedure(c,nil,7,7)
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
	e1:SetDescription(aux.Stringid(26045001,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetTarget(c26045001.target)
	e1:SetOperation(c26045001.operation)
	c:RegisterEffect(e1)
	--activate Planetheon Orbit
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26045001,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c26045001.fcon)
	e2:SetTarget(c26045001.ftg)
	e2:SetOperation(c26045001.fop)
	c:RegisterEffect(e2)
	--inactivate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(c26045001.aclimit)
	c:RegisterEffect(e3)
end
function c26045001.filter(c,e)
	return not c:IsImmuneToEffect(e)
end
function c26045001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	local gyg=Duel.GetMatchingGroup(c26045001.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e)
	if chk==0 then return tc and c:IsType(TYPE_XYZ) and #gyg>0 and not tc:IsType(TYPE_TOKEN) and tc:IsAbleToChangeControler() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,1)
end
function c26045001.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	local gyg=Duel.GetMatchingGroup(c26045001.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e)
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToBattle() and not tc:IsImmuneToEffect(e) and #gyg>0 then
		local sg=gyg:Select(tp,1,3,nil)
		sg:AddCard(tc)
		Duel.Overlay(c,sg,true)
	end
end
function c26045001.aclimit(e,re,tp)
	local rc=re:GetHandler():GetCode()
	local ov=e:GetHandler():GetOverlayGroup()
	return ov:IsExists(Card.IsCode,1,nil,rc)
end
function c26045001.fcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousSequence()>=5
end
function c26045001.ffilter(c,tp)
	return c:IsCode(26045008) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c26045001.ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26045001.ffilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
end
function c26045001.fop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26045001.ffilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc then
		Duel.ActivateFieldSpell(tc,e,tp,eg,ep,ev,re,r,rp)
	end
end