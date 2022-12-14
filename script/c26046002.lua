--Shatternal Mirragon
function c26046002.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	--Change scale
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(26046002,0))
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	--e0:SetCountLimit(1)
	e0:SetTarget(c26046002.sctg)
	e0:SetOperation(c26046002.scop)
	c:RegisterEffect(e0)
	--when destroyed
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26046002,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,26046002)
	e1:SetCondition(c26046002.condition)
	e1:SetTarget(c26046002.target)
	e1:SetOperation(c26046002.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26046002,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,{26046002,1})
	e2:SetCondition(c26046002.dcon)
	e2:SetTarget(c26046002.dtg)
	e2:SetOperation(c26046002.dop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26046002,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c26046002.spcon)
	e3:SetTarget(c26046002.sptg)
	e3:SetOperation(c26046002.spop)
	c:RegisterEffect(e3)
	
end
function c26046002.sctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_PZONE) and c26046003.scfilter(chkc,c) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsSetCard,tp,LOCATION_PZONE,0,1,c,0x646) end
	local tg=Duel.GetFirstMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,c,0x646)
	Duel.SetTargetCard(tg)
end
function c26046002.scop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,0,tc,e)
	if tc and tc:IsRelateToEffect(e) then
		local sg,sc=g:Select(tp,1,11,tc),0
		if Duel.IsPlayerAffectedByEffect(tp,26046000) or Duel.IsPlayerAffectedByEffect(tp,26046001) then
			sc=c26046001.shatter(e,tp,sg,true,REASON_EFFECT,nil)
		else 
			sc=Duel.Destroy(sg,REASON_EFFECT)
		end
		if sc>0 then
			local e1=Effect.CreateEffect(e:GetHandler())
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
function c26046002.spcon(e,tp,eg,ep,ev,re,r,rp)
	return #eg>1 and not eg:IsContains(e:GetHandler()) and r&REASON_EFFECT ==REASON_EFFECT and rp~=tp 
end
function c26046002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCountFromEx(tp,tp,nil,c)~=0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c26046002.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c26046002.dcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function c26046002.dtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c26046002.dop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFirstTarget()
	if tg and tg:IsRelateToEffect(e) then
		if Duel.IsPlayerAffectedByEffect(tp,26046000) or Duel.IsPlayerAffectedByEffect(tp,26046001) then
			c26046001.shatter(e,tp,tg,false,REASON_EFFECT,nil)
		else 
			Duel.Destroy(tg,REASON_EFFECT)
		end
	end
end
function c26046002.condition(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler())
end
function c26046002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	sg:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#sg,0,0)
end
function c26046002.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	sg:AddCard(e:GetHandler())
	if Duel.IsPlayerAffectedByEffect(tp,26046000) or Duel.IsPlayerAffectedByEffect(tp,26046001) then
		sg=c26046001.shatter(e,tp,sg,true,REASON_EFFECT,nil)
	else 
		sg=Duel.Destroy(sg,REASON_EFFECT)
	end
end
