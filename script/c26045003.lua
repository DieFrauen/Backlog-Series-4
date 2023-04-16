--Planetheon Father - Saturnus
function c26045003.initial_effect(c)
	Xyz.AddProcedure(c,nil,9,9)
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
	e1:SetDescription(aux.Stringid(26045003,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetTarget(c26045003.target)
	e1:SetOperation(c26045003.operation)
	c:RegisterEffect(e1)
	--attack all
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--activate Planetheon Horizon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26045003,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c26045003.fcon)
	e3:SetTarget(c26045003.ftg)
	e3:SetOperation(c26045003.fop)
	c:RegisterEffect(e3)
	--lock summons
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetTarget(c26045003.sumlimit)
	c:RegisterEffect(e4)
	local e4a=e4:Clone()
	e4a:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e4a)
	local e4b=e4:Clone()
	e4b:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e4b)
end
function c26045003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if chk==0 then return tc and c:IsType(TYPE_XYZ) and not tc:IsType(TYPE_TOKEN) and tc:IsAbleToChangeControler() end
end
function c26045003.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToBattle() and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(c,tc,true)
	end
end
function c26045003.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	local ov=e:GetHandler():GetOverlayGroup()
	return ov:IsExists(Card.IsCode,1,nil,c:GetCode())
end

function c26045003.fcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousSequence()>=5
end
function c26045003.ffilter(c,tp)
	return c:IsCode(26045006) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c26045003.ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26045003.ffilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
end
function c26045003.fop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26045003.ffilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc then
		Duel.ActivateFieldSpell(tc,e,tp,eg,ep,ev,re,r,rp)
	end
end