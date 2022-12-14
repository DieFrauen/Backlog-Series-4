--Shatternal Crystar
function c26046004.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	--Change scale
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26046004,3))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c26046004.sctg)
	e1:SetOperation(c26046004.scop)
	c:RegisterEffect(e1)
	--quick destroy
	local e2=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26046004,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,26046004)
	e2:SetTarget(c26046004.dtg)
	e2:SetOperation(c26046004.dop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26046004,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c26046004.spcon)
	e3:SetTarget(c26046004.sptg)
	e3:SetOperation(c26046004.spop)
	c:RegisterEffect(e3)
	--return to ed
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26046004,2))
	e4:SetCategory(CATEGORY_LEAVE_GRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCountLimit(1,{26046004,1})
	e4:SetTarget(c26046004.tdtg)
	e4:SetOperation(c26046004.tdop)
	c:RegisterEffect(e4)
	
end
function c26046004.sctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_PZONE) and c26046003.scfilter(chkc,c) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsSetCard,tp,LOCATION_PZONE,0,1,c,0x646) end
	local tg=Duel.GetFirstMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,c,0x646)
	Duel.SetTargetCard(tg)
end
function c26046004.scop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,0,tc,e)
	if tc and tc:IsRelateToEffect(e) then
		local sg=g:Select(tp,1,11,tc)
		if Duel.IsPlayerAffectedByEffect(tp,26046000) or Duel.IsPlayerAffectedByEffect(tp,26046001) then
			sc=c26046001.shatter(e,sg,true,REASON_EFFECT,nil)
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


function c26046004.spcon(e,tp,eg,ep,ev,re,r,rp)
	return #eg>1 and not eg:IsContains(e:GetHandler())
end
function c26046004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCountFromEx(tp,tp,nil,c)~=0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c26046004.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end

function c26046004.dfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c26046004.dtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c26046004.dfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c26046004.dfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function c26046004.dop(e,tp,eg,ep,ev,re,r,rp)
	local shatter=(Duel.IsPlayerAffectedByEffect(tp,26046000) or Duel.IsPlayerAffectedByEffect(tp,26046001))
	local g=Duel.GetTargetCards(e)
	if #g>0 then
		if shatter then
			sc=c26046001.shatter(e,tp,g,true,REASON_EFFECT,nil)
		else 
			sc=Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function c26046004.tdfilter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c26046004.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and c26046004.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26046004.tdfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c26046004.tdfilter,tp,LOCATION_GRAVE,0,2,2,nil)
end
function c26046004.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #sg>0 then
		Duel.SendtoExtraP(sg,tp,REASON_EFFECT)
	end
end
