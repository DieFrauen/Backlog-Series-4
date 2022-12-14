--Megiddon - Great Magnitude
function c26042004.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26042004,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c26042004.target)
	e1:SetOperation(c26042004.activate)
	c:RegisterEffect(e1)
end
c26042004.listed_names={26042001}
function c26042004.filter(c,e,tp,mg,ft,name)
	if not c:IsRitualMonster() or not c:IsSetCard(0x1642) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) or (name==true and not c:IsCode(26042001)) then return false end
	local pdk,odk=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0),Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)
	mg=mg:Filter(Card.IsCanBeRitualMaterial,c,c)
	local dk=pdk-odk
	local p1,p2=0,0
	local lv=c:GetLevel()
	if dk>0 then p1=dk else p2=math.abs(dk) end
	lev=lv-math.abs(dk)
	local p=tp
	if p2>p1 then p=1-tp end
	while lev>0 do
		if ft>0 then
			if mg:CheckWithSumEqual(Card.GetRitualLevel,lev,1,99,c)
			and (p1==0 or Duel.IsPlayerCanDiscardDeck(  tp,p1))
			and (p2==0 or Duel.IsPlayerCanDiscardDeck(1-tp,p2)) then return true end
		else
			if mg:IsExists(c26042005.filterF,1,nil,tp,mg,c,lev)
			and (p1==0 or Duel.IsPlayerCanDiscardDeck(  tp,p1))
			and (p2==0 or Duel.IsPlayerCanDiscardDeck(1-tp,p2)) then return true end
		end
		if p==tp then p1=p1+1 else p2=p2+1 end
		lev=lev-1
	end
	return mg:CheckWithSumEqual(Card.GetRitualLevel,lv,1,99,c)
end
function c26042004.filterF(c,tp,mg,rc,lv)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumEqual(Card.GetRitualLevel,lv,1,99,rc)
	else return false end
end
function c26042004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local mg=Duel.GetRitualMaterial(tp)
	if chk==0 then
		return ft>0
		and (Duel.IsExistingMatchingCard(c26042004.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg,ft,false)
		or Duel.IsExistingMatchingCard(c26042004.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,mg,ft,true))
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,  tp,0)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,0)
end
function c26042004.activate(e,tp,eg,ep,ev,re,r,rp)
	local pdk,odk=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0),Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)
	local dk=pdk-odk
	if dk>0 then p1=dk else p2=math.abs(dk) end
	local p1,p2=0,0
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local mg=Duel.GetRitualMaterial(tp)
	local g1=Duel.GetMatchingGroup(c26042004.filter,tp,LOCATION_HAND,0,nil,e,tp,mg,ft,false)
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(c26042004.filter),tp,LOCATION_GRAVE,0,nil,e,tp,mg,ft,true)
	g1:Merge(g2)
	local tg=g1:Select(tp,1,1,nil)
	if #tg<1 then return end
	local tc=tg:GetFirst()
	local lv=tc:GetLevel()
	local lev=lv
	mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
	for mc in aux.Next(mg) do
		local e1=Effect.CreateEffect(mc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_RITUAL_LEVEL)
		e1:SetValue(c26042004.rlevel)
		e1:SetReset(RESET_CHAIN)
		mc:RegisterEffect(e1)
	end
	if tc then
		local mat=Group.CreateGroup()
		if ft>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,lv,1,99,tc)
			lev=lev-mat:GetSum(Card.GetLevel)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:FilterSelect(tp,c26042004.filterF,1,1,nil,tp,mg,tc)
			Duel.SetSelectedCard(mat)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat2=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,lv,1,99,tc)
			mat:Merge(mat2)
			lev=lev-mat:GetSum(Card.GetLevel)
		end
		Duel.Release(mat,REASON_EFFECT)
		local p=tp
		if p2>p1 then p=1-tp end
		while lev>0 do
			if p==tp then p1=p1+1 else p2=p2+1 end
			mat:AddCard(Duel.GetDecktopGroup(p,1))
			Duel.DiscardDeck(p,math.max(1,dk),REASON_EFFECT+REASON_RELEASE)
			p=1-p; lev=lev-dk; dk=1
		end
		tc:SetMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c26042004.rlevel(e,c)
	local lv=e:GetHandler():GetLevel()
	local clv=c:GetLevel()
	return lv*65536+clv
end