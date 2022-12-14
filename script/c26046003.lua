--Shatternal Glassus
function c26046003.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	--Change scale
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(26046004,0))
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetCountLimit(1)
	e0:SetTarget(c26046003.sctg)
	e0:SetOperation(c26046003.scop)
	c:RegisterEffect(e0)
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c26046003.desrtg)
	e1:SetValue(c26046003.value)
	e1:SetOperation(c26046003.desrop)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c26046003.dam)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26046003,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c26046003.spcon)
	e3:SetTarget(c26046003.sptg)
	e3:SetOperation(c26046003.spop)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26046003,1))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,26046003)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetTarget(c26046003.drtg)
	e4:SetOperation(c26046003.drop)
	c:RegisterEffect(e4)
end
function c26046003.sctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_PZONE) and c26046003.scfilter(chkc,c) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsSetCard,tp,LOCATION_PZONE,0,1,c,0x646) end
	local tg=Duel.GetFirstMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,c,0x646)
	Duel.SetTargetCard(tg)
end
function c26046003.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,0,tc,e)
	if tc and tc:IsRelateToEffect(e) then
		local sg=g:Select(tp,1,11,tc)
		if Duel.IsPlayerAffectedByEffect(tp,26046000) or Duel.IsPlayerAffectedByEffect(tp,26046001) then
			sc=c26046001.shatter(e,tp,sg,true,REASON_EFFECT,nil)
		else 
			sc=Duel.Destroy(sg,REASON_EFFECT)
		end
		if sc>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LSCALE)
			e1:SetValue(sc)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_RSCALE)
			e2:SetValue(sc)
			tc:RegisterEffect(e2)
		end
	end
end
function c26046003.dam(e,tp,eg,ep,ev,re,r,rp)
	local d1=#eg*250
	Duel.Damage(1-tp,d1,REASON_EFFECT,true)
	Duel.RDComplete()
end
function c26046003.spcon(e,tp,eg,ep,ev,re,r,rp)
	return #eg>1 and not eg:IsContains(e:GetHandler()) and eg:FilterCount(Card.IsSetCard,nil,0x646)>1
end
function c26046003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c26046003.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end

function c26046003.dfilter(c,tp)
	return not c:IsReason(REASON_REPLACE) and c:IsFaceup() and Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0):IsContains(c) and c:IsType(TYPE_PENDULUM)
end
function c26046003.drfilter(c)
	return c:IsType(TYPE_PENDULUM)
	and c:IsFaceup()
	and c:IsDestructable()
end
function c26046003.desrtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local count=eg:FilterCount(c26046003.dfilter,nil,tp)
	if chk==0 then
		return count>0 and Duel.IsExistingMatchingCard(c26046003.drfilter,tp,LOCATION_EXTRA,0,count,nil)
	end
	while Duel.SelectEffectYesNo(tp,c,96) do
		local dg=Duel.GetMatchingGroup(c26046003.drfilter,tp,LOCATION_EXTRA,0,nil)
		sg=aux.SelectUnselectGroup(dg,e,tp,count,count,nil,1,tp,HINTMSG_DESREPLACE,nil,nil,true)
		if #sg==count then
			for ec in sg:Iter() do
				ec:SetStatus(STATUS_DESTROY_CONFIRMED,true)
			end
			e:SetLabelObject(sg)
			sg:KeepAlive()
			return true
		end
	end
	return false
end
function c26046003.value(e,c)
	return c:IsFaceup() and Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_ONFIELD,0):IsContains(c) and c:IsType(TYPE_PENDULUM)
end
function c26046003.desrop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,26046003)
	local tg=e:GetLabelObject()
		for ec in tg:Iter() do
			ec:SetStatus(STATUS_DESTROY_CONFIRMED,false)
		end
	Duel.Destroy(tg,REASON_EFFECT+REASON_REPLACE)
	tg:DeleteGroup()
end

function c26046003.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c26046003.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
