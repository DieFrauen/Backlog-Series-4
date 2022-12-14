--Shatternal Fallout
function c26046011.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26046011,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c26046011.condition)
	e1:SetTarget(c26046011.target)
	e1:SetOperation(c26046011.activate)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26046011,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,26046011)
	e2:SetCondition(c26046011.descon)
	e2:SetTarget(c26046011.destg)
	e2:SetOperation(c26046011.desop)
	c:RegisterEffect(e2)
	--set to field 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26046007,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,{26046011,1})
	e3:SetCondition(c26046011.setcon)
	e3:SetTarget(c26046011.settg)
	e3:SetOperation(c26046011.setop)
	c:RegisterEffect(e3)
end
function c26046011.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsDestructable()
end
function c26046011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
end
function c26046011.activate(e,tp,eg,ep,ev,re,r,rp)
	local shatter=(Duel.IsPlayerAffectedByEffect(tp,26046000) or Duel.IsPlayerAffectedByEffect(tp,26046001))
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) then
		if shatter then
			c26046001.shatter(e,tp,rc,false,REASON_EFFECT,nil)
		else 
			Duel.Destroy(rc,REASON_EFFECT)
		end
	end
end
function c26046011.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c26046011.pfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return #g>0 end
end
function c26046011.dfilter(c)
	return c:IsSetCard(0x646) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c26046011.descon(e,tp,eg,ep,ev,re,r,rp)
	return (r&REASON_DESTROY)~=0
		and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c26046011.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26046011.tefilter,tp,LOCATION_DECK,0,1,nil) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
end

function c26046011.desop(e,tp,eg,ep,ev,re,r,rp)
	local shatter=(Duel.IsPlayerAffectedByEffect(tp,26046000) or Duel.IsPlayerAffectedByEffect(tp,26046001))
	local g=Duel.GetMatchingGroup(c26046011.dfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 then
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			if not Duel.SelectYesNo(tp,aux.Stringid(26046011,2)) then return end
			local dg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
			if shatter then
				c26046001.shatter(e,tp,dg,true,REASON_EFFECT,nil)
			else 
				Duel.Destroy(dg,REASON_EFFECT)
			end
		end
	end
end
function c26046011.setcon(e,tp,eg,ep,ev,re,r,rp)
	return #eg>1 and not eg:IsContains(e:GetHandler())
end
function c26046011.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c26046011.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
		--Banish it if it leaves the field
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(3300)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
end