--Planetheon Ruler - Jovianus
function c26045004.initial_effect(c)
	Xyz.AddProcedure(c,nil,10,10)
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
	e1:SetDescription(aux.Stringid(26045004,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetTarget(c26045004.target)
	e1:SetOperation(c26045004.operation)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c26045004.immval)
	c:RegisterEffect(e2)
	--activate Planetheon Orbit
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26045001,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c26045001.fcon)
	e3:SetTarget(c26045001.ftg)
	e3:SetOperation(c26045001.fop)
	c:RegisterEffect(e3)
end
function c26045004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	local dg=Duel.GetDecktopGroup(1-tp,3)
	if chk==0 then return tc and c:IsType(TYPE_XYZ) and #dg==3 and not tc:IsType(TYPE_TOKEN) and tc:IsAbleToChangeControler() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,1)
end
function c26045004.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	local dg=Duel.GetDecktopGroup(1-tp,3)
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToBattle() and not tc:IsImmuneToEffect(e) and #dg==3 then
		dg:AddCard(tc)
		Duel.Overlay(c,dg,true)
	end
end
function c26045004.immval(e,te)
	local tc=te:GetOwner()
	local ov=e:GetHandler():GetOverlayGroup()
	return ov:IsExists(Card.IsCode,1,nil,tc:GetCode())
end

function c26045004.fcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousSequence()>=5
end
function c26045004.ffilter(c,tp)
	return c:IsSetCard(0x645) and c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c26045004.ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26045004.ffilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,tp) end
end
function c26045004.fop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26045004.ffilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc then
		Duel.ActivateFieldSpell(tc,e,tp,eg,ep,ev,re,r,rp)
	end
end