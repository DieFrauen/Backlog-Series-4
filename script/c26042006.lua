--Meggidon - Falling Sky
function c26042006.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26042006,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c26042006.target)
	e1:SetOperation(c26042006.activate)
	c:RegisterEffect(e1)
	
end
c26042006.listed_names={26042003}
function c26042006.filter(c,e,tp,mg1,mg2,ft,name)
	if not c:IsRitualMonster()
		or not c:IsSetCard(0x1642)
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
		or (name==true and not c:IsCode(26042003))
		then return false end
	local mg=mg1:Filter(Card.IsCanBeRitualMaterial,c,c)
	mg:Merge(mg2)
	if ft>0 then
		return mg:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
	else
		return mg:IsExists(c26042006.filterF,1,nil,tp,mg1,c)
	end
end
function c26042006.filterF(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumGreater(Card.GetRitualLevel,rc:GetLevel(),rc)
	else return false end
end
function c26042006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		local mg2=Duel.GetMatchingGroup(Card.IsPublic,tp,0,LOCATION_MZONE+LOCATION_HAND,nil)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return ft>-1 and Duel.IsExistingMatchingCard(c26042006.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg1,mg2,ft,false) or Duel.IsExistingMatchingCard(c26042006.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,mg1,mg2,ft,true) 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c26042006.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterial(tp)
	local mg2=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE+LOCATION_HAND,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.GetMatchingGroup(c26042006.filter,tp,LOCATION_HAND,0,nil,e,tp,mg1,mg2,ft,false)
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(c26042006.filter),tp,LOCATION_GRAVE,0,nil,e,tp,mg1,mg2,ft,true)
	g1:Merge(g2)
	local tg=g1:Select(tp,1,1,nil)
	local tc=tg:GetFirst()
	if tc then
		mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:Merge(mg2)
		local mat=nil
		if ft>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:FilterSelect(tp,c26042006.filterF,1,1,nil,tp,mg1,mg2,tc)
			Duel.SetSelectedCard(mat)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat2=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
			mat:Merge(mat2)
		end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.ShuffleHand(1-tp)
		Duel.ShuffleHand(tp)
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end