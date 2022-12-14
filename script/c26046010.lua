--Shatternal Fragility
function c26046010.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_LEAVE_GRAVE)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetOperation(c26046010.activate)
	c:RegisterEffect(e0)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLED)
	e1:SetRange(LOCATION_SZONE)
	e1:SetOperation(c26046010.regop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetLabel(26046011)
	e2:SetCondition(c26046010.descon)
	e2:SetOperation(c26046010.desop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c26046010.regop2)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetLabel(26046010)
	e4:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e4:SetCountLimit(1)
	c:RegisterEffect(e4)
	aux.GlobalCheck(c26046010,function()
		c26046010[0]=0
		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge4:SetCode(EVENT_DESTROY)
		ge4:SetOperation(c26046010.checkop)
		Duel.RegisterEffect(ge4,0)
		aux.AddValuesReset(function()
			c26046010[0]=0
		end)
	end)
	--Send itself to the GY
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c26046010.tgcon)
	e3:SetOperation(c26046010.tgop)
	c:RegisterEffect(e3)
end
function c26046010.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	for tc in aux.Next(eg) do
		c26046010[0]=c26046010[0]+1
	end
end
function c26046010.filter(c)
	return c:IsSetCard(0x646) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c26046010.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26046010,0))
	local g=Duel.GetMatchingGroup(c26046010.filter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(26046010,1)) then
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end
function c26046010.regop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc and not tc:IsSetCard(0x646) then
		tc:RegisterFlagEffect(26046010,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c26046010.regop2(e,tp,eg,ep,ev,re,r,rp)
	local ch=Duel.GetCurrentChain()
	local e1=Duel.GetChainInfo(ch,CHAININFO_TRIGGERING_EFFECT)
	local ec=e1:GetHandler()
	if e1:IsHasType(EFFECT_TYPE_ACTIVATE) or ec:IsStatus(STATUS_SUMMON_TURN+STATUS_FLIP_SUMMON_TURN+STATUS_SPSUMMON_TURN) then return end
	if not ec:IsOnField() then return end
	if ec:IsSetCard(0x646) then return end
	ec:RegisterFlagEffect(26046011,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c26046010.dfilter(c,code)
	return c:GetFlagEffect(code)~=0
end
function c26046010.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c26046010.dfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e:GetLabel())>0
end
function c26046010.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c26046010.dfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e:GetLabel())
	if #sg==0 then return end
	Duel.Hint(HINT_CARD,tp,26046010)
	Duel.Destroy(sg,REASON_EFFECT)
end
function c26046010.tgcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsTurnPlayer(tp) and c26046010[0]==0
end
function c26046010.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end