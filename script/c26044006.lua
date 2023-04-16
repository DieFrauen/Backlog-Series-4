--Regiamorph Mantaris
function c26044006.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterSummonCode(26044001),1,1,nil,1,99)
	c:EnableReviveLimit()
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(1)
	e1:SetCondition(c26044006.actcon)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26044006,1))
	e2:SetCategory(CATEGORY_COUNTER+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetCondition(c26044006.condition)
	e2:SetOperation(c26044006.operation)
	c:RegisterEffect(e2)
	--Add counter2
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_LEAVE_FIELD_P)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c26044006.addop2)
	c:RegisterEffect(e3)
end
function c26044006.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end
function c26044006.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc and bc:IsRelateToBattle()
	and c:IsCanRemoveCounter(tp,0x1045,1,REASON_EFFECT)
end
function c26044006.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsFaceup() and c:IsRelateToBattle() and bc:IsFaceup() and bc:IsRelateToBattle() and c:IsCanRemoveCounter(tp,0x1045,1,REASON_EFFECT) then
		local ct=c:GetCounter(0x1045)
		c:RemoveCounter(tp,0x1045,ct,REASON_EFFECT)
		bc:AddCounter(0x1045,ct)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*-100)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		bc:RegisterEffect(e1)
	end
end
function c26044006.addop2(e,tp,eg,ep,ev,re,r,rp)
	local count=0
	local c=e:GetHandler()
	for tc in aux.Next(eg) do
		if tc~=c and tc:IsLocation(LOCATION_ONFIELD) and tc:IsReason(REASON_DESTROY+REASON_BATTLE) then
			ct=tc:GetCounter(0x1045)
			if tc:RemoveCounter(tp,0x1045,ct,REASON_EFFECT) then
				count=count+ct
			end
		end
	end
	if count>0 then
		c:AddCounter(0x1045,count)
		Duel.Recover(tp,count*100,REASON_EFFECT)
	end
end