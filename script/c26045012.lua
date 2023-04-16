--Planetheon Ensnare
function c26045012.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	-- Attach 1 card from gy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c26045012.ovop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26045012,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetTarget(c26045012.tgtg)
	e3:SetOperation(c26045012.tgop)
	c:RegisterEffect(e3)
end
function c26045012.xyzfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x645) and c:GetOverlayCount()>2 and c:GetSequence()>=5
end
function c26045012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local p1=Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,26045008),tp,LOCATION_ONFIELD,0,1,nil)
	local p2=Duel.IsExistingMatchingCard(c26045012.xyzfilter,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then e:GetLabelObject():SetLabel(0) return (p1 or p2) end
	if e:GetLabelObject():GetLabel()>0 then
		e:GetLabelObject():SetLabel(0)
		if p2 and not p1 then
			local tc=Duel.SelectMatchingCard(tp,c26045012.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
			local g=tc:GetOverlayGroup():Select(tp,1,1,nil)
			Duel.SendtoGrave(g,REASON_COST)
		end
	end
end

function c26045012.attfilter(c,e)
	return not c:IsImmuneToEffect(e) and
	(  c:IsPreviousLocation(LOCATION_ONFIELD)
	or c:IsPreviousLocation(LOCATION_DECK)
	or c:IsPreviousLocation(LOCATION_HAND))
end
function c26045012.xyzfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetOverlayCount()>2 and c:GetSequence()>=5
end
function c26045012.nep(c)
	return c:IsFaceup() and c:IsCode(26045001,26045008)
end
function c26045012.ovop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetMatchingGroup(c26045012.xyzfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local nep=Duel.IsExistingMatchingCard(c26045012.nep,tp,LOCATION_ONFIELD,0,1,nil)
	if #tc==1 and nep then tc=tc:GetFirst() else return end
	local g=eg:Filter(aux.NecroValleyFilter(c26045012.attfilter),nil,e)
	if #g>0 and tc:IsType(TYPE_XYZ) then
		Duel.Overlay(tc,g)
	end
end

function c26045012.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,2,REASON_EFFECT) and ct>0 end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_HAND)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_ONFIELD)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DECKDES,nil,1,tp,1)
end
function c26045012.tgop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ct,p1,p2,p3,sg=0,true,true,true,Group.CreateGroup()
	local dck=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)-Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if dck>0 then
		ct=ct+dck else p1=false
	end
	local fld=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)-Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	if fld>0 then
		ct=ct+fld else p2=false
	end
	local hd=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if hd>0 then
		ct=ct+hd else p3=false
	end
	Duel.RemoveOverlayCard(tp,1,0,1,ct,REASON_EFFECT)
	local ov=#Duel.GetOperatedGroup()
	Duel.Hint(HINT_NUMBER,tp,ov)
	while ov>0 and (p1 or p2 or p3) do
		Duel.BreakEffect()
		local op=Duel.SelectEffect(1-tp,
			{p1,aux.Stringid(26045012,1)},
			{p2,aux.Stringid(26045012,2)},
			{p3,aux.Stringid(26045012,3)})
		if op==1 then
			Duel.DiscardDeck(1-tp,1,REASON_EFFECT)
			p1=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)-Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		elseif op==2 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
			sg=Duel.SelectMatchingCard(1-tp,nil,1-tp,LOCATION_ONFIELD,0,1,1,nil):GetFirst()
			if sg then
				Duel.HintSelection(sg)
				Duel.SendtoGrave(sg,REASON_EFFECT)
				p2=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)-Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)>0
			end
		elseif op==3 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
			sg=Duel.SelectMatchingCard(1-tp,nil,1-tp,LOCATION_HAND,0,1,1,nil):GetFirst()
			if sg then
				Duel.HintSelection(sg)
				Duel.SendtoGrave(sg,REASON_EFFECT)
				p3=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0
			end
		end
		ov=ov-1
	end
end