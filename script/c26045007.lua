--Planetheon Horizon
function c26045007.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26045007,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26045005)
	e1:SetTarget(c26045007.target)
	e1:SetOperation(c26045007.operation)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26045007,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e2:SetTarget(c26045007.target2)
	e2:SetOperation(c26045007.operation2)
	c:RegisterEffect(e2)
end

function c26045007.filter(c,e,tp,rp)
	local rk=c:GetRank()
	local hd,ohd=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0),Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if e:GetHandler():IsLocation(LOCATION_HAND) then hd=hd-1 end
	local hc=hd+ohd
	return c:IsSetCard(0x645)
	and hc==rk
	and Duel.GetLocationCountFromEx(tp,rp,nil,c,0x60)>0
	and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,true)
end
function c26045007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local h1,h2=Duel.GetMatchingGroupCount(nil,tp,LOCATION_HAND,0,e:GetHandler()),Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if c:IsLocation(LOCATION_HAND) then h1=h1-1 end
	if chk==0 then return Duel.IsExistingMatchingCard(c26045007.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,rp)
	and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
	and Duel.IsPlayerCanDraw(tp,h1)
	and Duel.IsPlayerCanDraw(1-tp,h2) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DRAW,nil,h1,tp,h1)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DRAW,nil,h2,1-tp,h2)
end
function c26045007.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c26045007.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,rp):GetFirst()
	local rk=tc:GetRank()
	local dc1,dc2=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0),Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,true,POS_FACEUP,0x60)
		local h1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		local h2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		local dc1,dc2=#h1,#h2
		Duel.Overlay(tc,h1)
		Duel.Overlay(tc,h2)
		Duel.Draw(tp,dc1,REASON_EFFECT)
		Duel.Draw(1-tp,dc2,REASON_EFFECT)
		tc:CompleteProcedure()
	end
end
function c26045007.filter2(c,e,tp,rp)
	local rk=c:GetRank()
	local h1,h2=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0),Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	return c:IsType(TYPE_XYZ) and h1>0 and h2>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,true)
end
function c26045007.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26045007.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,rp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c26045007.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c26045007.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,rp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,true,POS_FACEUP)~=0 then
		local ovg=Group.FromCards(e:GetHandler())
		ovg:AddCard(Group.RandomSelect(Duel.GetFieldGroup(tp,LOCATION_HAND,0),tp,1))
		ovg:AddCard(Group.RandomSelect(Duel.GetFieldGroup(tp,0,LOCATION_HAND),tp,1))
		Duel.Overlay(tc,ovg)
	end
end