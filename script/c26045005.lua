--Planetheon Dominion
function c26045005.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26045005,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c26045005.target)
	e1:SetOperation(c26045005.operation)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26045005,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e2:SetTarget(c26045005.target2)
	e2:SetOperation(c26045005.operation2)
	c:RegisterEffect(e2)
end
function c26045005.filter(c,e,tp,rp)
	local rk=c:GetRank()
	local dc=Duel.GetFieldGroupCount(0,LOCATION_DECK,LOCATION_DECK)
	local df=math.abs(Duel.GetFieldGroupCount(0,LOCATION_DECK,0)-Duel.GetFieldGroupCount(1,LOCATION_DECK,0)) 
	return c:IsSetCard(0x645) and rk<=dc and rk-6<=df and Duel.GetLocationCountFromEx(tp,rp,nil,c,0x60)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,true)
end
function c26045005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26045005.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,rp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c26045005.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c26045005.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,rp):GetFirst()
	local rk=tc:GetRank()
	local dc1,dc2=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0),Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)
	local df=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)-Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)
	local p=tp; if df<0 then p=1-tp end
	if tc then
		--Debug.PreSummon(tc,SUMMON_TYPE_XYZ,0x60)
		Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,true,POS_FACEUP,0x60)
		Duel.DisableShuffleCheck()
		while rk>0 do
			mat=Duel.GetDecktopGroup(p,1)
			Duel.Overlay(tc,mat)
			dc1=Duel.GetFieldGroupCount(0,LOCATION_DECK,0)
			dc2=Duel.GetFieldGroupCount(1,LOCATION_DECK,0)
			df=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)-Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)
			if df<0 then p=1-tp else p=tp end
			rk=rk-1
		end
	end
end
function c26045005.filter2(c,e,tp,rp)
	local rk=c:GetRank()
	local dc1,dc2=Duel.GetDecktopGroup(0,1),Duel.GetDecktopGroup(1,1)
	return c:IsType(TYPE_XYZ) and #dc1+#dc2==2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,true)
end
function c26045005.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26045005.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,rp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c26045005.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c26045005.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,rp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,true,POS_FACEUP)~=0 then
		local ovg=Group.FromCards(e:GetHandler())
		ovg:Merge(Duel.GetDecktopGroup(0,1))
		ovg:Merge(Duel.GetDecktopGroup(1,1))
		Duel.DisableShuffleCheck()
		Duel.Overlay(tc,ovg)
	end
end