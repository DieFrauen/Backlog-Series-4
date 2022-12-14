--Meggidon - Giant Deluge
function c26042005.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26042005,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c26042005.target)
	e1:SetOperation(c26042005.activate)
	c:RegisterEffect(e1)
end
c26042005.listed_names={26042002}
function c26042005.ritfilter(c)
	return c:IsPublic() and c:GetType()&TYPE_RITUAL ==0 and c:IsAbleToRemove()
end
function c26042005.filter(c,e,tp,mg,ft,name)
	if not c:IsRitualMonster()
		or not c:IsSetCard(0x1642)
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
		or (name==true and not c:IsCode(26042002))
		then return false end
	if ft>0 then
		return mg:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
	else
		return mg:IsExists(c26042005.filterF,1,nil,tp,mg,c)
	end
end
function c26042005.filterF(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumGreater(Card.GetRitualLevel,rc:GetLevel(),rc)
	else return false end
end
function c26042005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c26042005.ritfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,c)
		return ft>-1
		and (Duel.IsExistingMatchingCard(c26042005.filter,tp,LOCATION_HAND,0,1,c,e,tp,mg,ft,false)
		or Duel.IsExistingMatchingCard(c26042005.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,mg,ft,true)) 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c26042005.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(c26042005.ritfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.GetMatchingGroup(c26042005.filter,tp,LOCATION_HAND,0,nil,e,tp,mg,ft,false)
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(c26042005.filter),tp,LOCATION_GRAVE,0,nil,e,tp,mg,ft,true)
	g1:Merge(g2)
	local tg=g1:Select(tp,1,1,nil)
	local tc=tg:GetFirst()
	local op=1-tp
	if tc then
		local mat=nil
		if ft>0 then
			Duel.Hint(HINT_SELECTMSG,op,HINTMSG_RELEASE)
			mat=mg:SelectWithSumGreater(op,Card.GetRitualLevel,tc:GetLevel(),tc)
		else
			Duel.Hint(HINT_SELECTMSG,op,HINTMSG_RELEASE)
			mat=mg:FilterSelect(op,c26042005.filterF,1,1,nil,tp,mg,tc)
			Duel.SetSelectedCard(mat)
			Duel.Hint(HINT_SELECTMSG,op,HINTMSG_RELEASE)
			local mat2=mg:SelectWithSumGreater(op,Card.GetRitualLevel,tc:GetLevel(),tc)
			mat:Merge(mat2)
		end
		tc:SetMaterial(mat)
		Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_RELEASE)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end