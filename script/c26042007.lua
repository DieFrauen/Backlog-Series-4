--Shrine of Meggidon
function c26042007.initial_effect(c)
	c:EnableCounterPermit(0x25)
	c:SetCounterLimit(0x25,10)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_TO_HAND)
	e0:SetRange(LOCATION_SZONE)
	e0:SetCondition(c26042007.check)
	e0:SetOperation(c26042007.checkop)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--count 
	if not c26042007.global_check then
		c26042007.global_check=true
		c26042007[0]=0
		c26042007[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetRange(LOCATION_SZONE)
		ge1:SetOperation(c26042007.dkop)
		Duel.RegisterEffect(ge1,0)
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CUSTOM+26042007)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c26042007.count)
	c:RegisterEffect(e2)
	--confirm deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26042007,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_PREDRAW)
	e3:SetCondition(c26042007.cfcon)
	e3:SetOperation(c26042007.cfop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_HAND)
	e4:SetRange(LOCATION_HAND)
	e4:SetCondition(c26042007.tfcon)
	e4:SetTarget(c26042007.tftg)
	e4:SetOperation(c26042007.tfop)
	c:RegisterEffect(e4)
end
function c26042007.checkg(c)
	return c:GetPreviousLocation()==LOCATION_DECK and not c:IsReason(REASON_DRAW)
end
function c26042007.check(e,tp,eg,ep,ev,re,r,rp)
	return eg:FilterCount(c26042007.checkg,nil)>0 and rp==tp
end
function c26042007.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c26042007.dkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dk1=Duel.GetFieldGroupCount(0,LOCATION_DECK,0)
	local dk2=Duel.GetFieldGroupCount(1,LOCATION_DECK,0)
	local val=0
	if c26042007[0]~=dk1 then
		val=c26042007[0]-dk1
		c26042007[0]=dk1
		if val>0 then Duel.RaiseEvent(c,EVENT_CUSTOM+26042007,e,REASON_ADJUST,tp,tp,val) end
	end
	if c26042007[1]~=dk2 then
		val=c26042007[1]-dk2
		c26042007[1]=dk2
		if val>0 then Duel.RaiseEvent(c,EVENT_CUSTOM+26042007,e,REASON_ADJUST,tp,tp,val) end
	end
end
function c26042007.count(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x25,ev,true)
end
function c26042007.cfcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and e:GetHandler():IsCanRemoveCounter(tp,0x25,2,REASON_EFFECT)
end
function c26042007.cfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct={}
	for i=10,1,-1 do
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=i and c:IsCanRemoveCounter(tp,0x25,i,REASON_EFFECT) then
			table.insert(ct,i)
		end
	end
	local ac=Duel.AnnounceNumber(tp,table.unpack(ct))
	c:RemoveCounter(tp,0x25,ac,REASON_EFFECT)
	local g=Duel.GetDecktopGroup(tp,ac)
	Duel.ConfirmCards(tp,g)
	Duel.SortDecktop(tp,tp,ac)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_HAND)
	e1:SetTargetRange(LOCATION_DECK,0)
	Duel.RegisterEffect(e1,tp)
end

function c26042007.tfcheck(c)
	return c:GetPreviousLocation()==LOCATION_DECK 
end
function c26042007.tfcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:FilterCount(c26042007.tfcheck,nil)>0 and rp~=tp and (r&REASON_EFFECT)~=0
end
function c26042007.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and not e:GetHandler():IsForbidden() end
end

function c26042007.tfop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local c=e:GetHandler()
	if c then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		c:AddCounter(0x25,3)
	end
end