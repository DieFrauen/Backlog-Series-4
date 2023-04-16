--Planetheon Orbit
function c26045008.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26045008,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCountLimit(1,26045005)
	e1:SetTarget(c26045008.target)
	e1:SetOperation(c26045008.operation)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26045008,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c26045008.target2)
	e2:SetOperation(c26045008.operation2)
	c:RegisterEffect(e2)
end


function c26045008.filter(c,e,tp,rp)
	local rk=c:GetRank()
	local hc=Duel.GetFieldGroupCount(0,LOCATION_GRAVE,LOCATION_GRAVE)
	return c:IsSetCard(0x645) and rk<=hc and Duel.GetLocationCountFromEx(tp,rp,nil,c,0x60)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,true)
end
function c26045008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local gy=Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,LOCATION_GRAVE)
	if chk==0 then return Duel.IsExistingMatchingCard(c26045008.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,rp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,1)
end
function c26045008.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c26045008.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,rp):GetFirst()
	local rk=tc:GetRank()
	local dc1,dc2=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0),Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)
	if tc then
		--Debug.PreSummon(tc,SUMMON_TYPE_XYZ,0x60)
		Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,true,POS_FACEUP,0x60)
		local gy=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_GRAVE,LOCATION_GRAVE,rk,rk,nil)
		Duel.Overlay(tc,gy)
		--tc:CompleteProcedure()
	end
end
function c26045008.filter2(c,e,tp,rp)
	local g1,g2=Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0),Duel.GetFieldGroupCount(tp,0,LOCATION_GRAVE)
	return c:IsType(TYPE_XYZ) and g1>0 and g2>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,true)
end
function c26045008.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26045008.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,rp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,1)
end
function c26045008.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c26045008.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,rp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,true,POS_FACEUP)~=0 then
		local tg1=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
		local tg2=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_GRAVE,1,1,nil):GetFirst()
		local ovg=Group.FromCards(e:GetHandler(),tg1,tg2)
		Duel.Overlay(tc,ovg)
	end
end