--Regiamorph Siphonon
function c26044002.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26044002,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e1:SetTarget(c26044002.sptg)
	e1:SetOperation(c26044002.spop)
	c:RegisterEffect(e1)
	--search top deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26044002,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(2,26044002,EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c26044002.exctg)
	e2:SetOperation(c26044002.excop)
	c:RegisterEffect(e2)
	local e2a=e2:Clone()
	e2a:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2a)
	local e2b=e2:Clone()
	e2b:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2b)
	
end
function c26044002.filter(c,tp)
	return c:IsFaceup() and c:IsCanRemoveCounter(tp,0x1045,1,REASON_EFFECT)
end
function c26044002.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c26044002.filter(chkc) end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c26044002.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26044002,1))
	Duel.SelectTarget(tp,c26044002.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c26044002.spop(e,tp,eg,ep,ev,re,r,rp)
	local c,tc=e:GetHandler(),Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or not tc:IsCanRemoveCounter(tp,0x1045,1,REASON_EFFECT) then return end
	if c:IsRelateToEffect(e) and tc:RemoveCounter(tp,0x1045,1,REASON_EFFECT) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetAbsoluteRange(tp,1,0)
		e1:SetTarget(c26044002.splimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1,true)
	end
end
function c26044002.splimit(e,c)
	return not c:HasLevel()
end

function c26044002.ctfilter(c,eg)
	local ct=c:GetCounter(0x1045)
	local dk=Duel.GetDecktopGroup(c:GetControler(),math.min(5,ct))
	return c:IsFaceup() and ct>0 and dk:IsExists(Card.IsAbleToHand,1,nil) and eg:IsContains(c)
end
function c26044002.exctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c26044002.ctfilter(chkc,eg) end
	if chk==0 then return Duel.IsExistingTarget(c26044002.ctfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,eg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c26044002.ctfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c,eg)
end
function c26044002.thfilter(c)
	return c:IsSetCard(0x644) and c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c26044002.excop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local ct=tc:GetCounter(0x1045)
	local p=tc:GetControler()
	if not tc:IsRelateToEffect(e) or ct==0 or ct>Duel.GetFieldGroupCount(p,LOCATION_DECK,0) then return end
	ct=math.min(5,ct)
	local g=Duel.GetDecktopGroup(p,ct)
	Duel.ConfirmCards(tp,g)
	if g:IsExists(c26044002.thfilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(26044002,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,c26044002.thfilter,1,1,nil)
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		if ct>1 then Duel.SortDecktop(tp,p,ct-1) end
	elseif ct>0 then Duel.SortDecktop(tp,p,ct) end
end