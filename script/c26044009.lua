--Regiamorph Paradise
function c26044009.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetLabel(0)
	e1:SetOperation(c26044009.activate)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetDescription(aux.Stringid(26044009,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetLabel(1)
	e2:SetCountLimit(1)
	e2:SetCondition(c26044009.accon)
	e2:SetTarget(c26044009.actg)
	e2:SetOperation(c26044009.activate)
	c:RegisterEffect(e2)
	--add counter
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetOperation(c26044009.ctop)
	c:RegisterEffect(e3)
	local e3a=e3:Clone()
	e3a:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3a)
	local e3b=e3:Clone()
	e3b:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3b)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetValue(c26044009.immval)
	c:RegisterEffect(e1)
	--Add counter2
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_LEAVE_FIELD_P)
	e5:SetRange(LOCATION_FZONE)
	e5:SetOperation(c26044009.ctspop)
	c:RegisterEffect(e5)
	
end
c26044009.listed_series={0x644}
c26044009.counter_place_list={0x1045}

function c26044009.immval(e,te)
	local tc=te:GetOwner()
	return tc:GetCounter(0x1045)>0 and te:GetHandlerPlayer()~=e:GetHandlerPlayer()
end
function c26044009.accon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c26044009.thfilter(c)
	return c:IsSetCard(0x1644) and c:IsAbleToHand()
end
function c26044009.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26044009.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c26044009.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c26044009.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if #g>0 and (e:GetLabel()~=0 or Duel.SelectYesNo(tp,aux.Stringid(26044009,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c26044009.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	for tc in aux.Next(eg) do
		if tc:IsFaceup() and tc:HasLevel() --and not tc:IsSetCard(0x644)
		then
			tc:AddCounter(0x1045,tc:GetLevel())
		end
	end
end
function c26044009.ctspop(e,tp,eg,ep,ev,re,r,rp)
	local count=0
	for c in aux.Next(eg) do
		if c:GetCounter(0x1045)>0 and c:IsReason(REASON_MATERIAL|REASON_SUMMON) then
			count=c:GetCounter(0x1045)
			local e1=Effect.CreateEffect(c)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_BE_MATERIAL)
			e1:SetLabel(count)
			e1:SetCondition(c26044009.efcon)
			e1:SetOperation(c26044009.efop)
			c:RegisterEffect(e1)
		end
	end
end
function c26044009.efcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler():GetReasonCard()
	return rc:IsFaceup() and
	(r&(REASON_SYNCHRO|REASON_FUSION|REASON_RITUAL|REASON_LINK)~=0 or
	 r==REASON_SUMMON) 
end
function c26044009.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	rc:AddCounter(0x1045,e:GetLabel())
	e:Reset()
end