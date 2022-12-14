--Wrath of the Superancients
function c26042012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26042012,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c26042012.condition1)
	e1:SetTarget(c26042012.target1)
	e1:SetOperation(c26042012.activate1)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26042012,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_HANDES)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCondition(c26042012.condition2)
	e2:SetTarget(c26042012.target2)
	e2:SetOperation(c26042012.activate2)
	c:RegisterEffect(e2)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26042012,2))
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c26042012.condition3)
	e3:SetTarget(c26042012.target3)
	e3:SetOperation(c26042012.activate3)
	c:RegisterEffect(e3)
	--Activate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26042012,3))
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c26042012.condition4)
	e4:SetTarget(c26042012.target4)
	e4:SetOperation(c26042012.activate4)
	c:RegisterEffect(e4)
end
function c26042012.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x642) and c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function c26042012.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c26042012.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsChainNegatable(ev)
end
function c26042012.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c26042012.activate1(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		ec:CancelToGrave()
		Duel.SendtoDeck(ec,nil,2,REASON_EFFECT)
	end
end
function c26042012.filter2(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK) and not c:IsReason(REASON_DRAW)
end
function c26042012.condition2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c26042012.filter2,1,nil,1-tp)
end
function c26042012.disfilter(c,typ)
	return c:IsDiscardable() and c:GetType()&typ==typ
end
function c26042012.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26042012.disfilter,tp,LOCATION_HAND,0,1,nil,0x81) and Duel.IsExistingMatchingCard(c26042012.disfilter,tp,LOCATION_HAND,0,1,nil,0x82) end
	local g=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,g)
end

function c26042012.resfilter(c,typ)
	return c:GetType()&typ==typ
end
function c26042012.rescon(sg,e,tp,mg)
	return sg:IsExists(c26042012.resfilter,1,nil,0x81) and sg:IsExists(c26042012.resfilter,1,nil,0x82)
end
function c26042012.activate2(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,c,REASON_EFFECT)
	sg=aux.SelectUnselectGroup(g1,e,tp,2,2,c26042012.rescon,1,tp,HINTMSG_DISCARD,c26042012.rescon)
	g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	sg:Merge(g2)
	Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
end

function c26042012.filter3(c,tp)
	return c:IsPreviousLocation(LOCATION_DECK)
end
function c26042012.condition3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c26042012.filter3,1,nil,1-tp) and not re:IsHasCategory(CATEGORY_DECKDES) and rp~=tp
end

function c26042012.remfilter(c)
	return c:IsAbleToRemove() and aux.SpElimFilter(c)
end
function c26042012.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26042012.remfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
	if Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),69832741) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_MZONE)
	else
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_GRAVE)
	end
end
function c26042012.activate3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c26042012.remfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end

function c26042012.filter4(c,tp)
	return c:IsPreviousLocation(LOCATION_DECK)
end
function c26042012.condition4(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c26042012.filter3,1,nil,1-tp) and rp~=tp
end
function c26042012.tffilter(c,e,tp)
	return c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function c26042012.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>=0 and Duel.IsExistingMatchingCard(c26042012.tffilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c26042012.activate4(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tc=Duel.SelectMatchingCard(tp,c26042012.tffilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if tc and ft>=0 then
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	end
end