--Planetheon Origin
function c26045009.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c26045009.activate)
	c:RegisterEffect(e1)
	--Copy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26045009,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,26045009)
	e2:SetCost(c26045009.cost)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c26045009.target)
	e2:SetOperation(c26045009.operation)
	c:RegisterEffect(e2)
	--attach from deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26045009,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,26045009)
	e3:SetTarget(c26045009.detg)
	e3:SetOperation(c26045009.deop)
	c:RegisterEffect(e3,false,REGISTER_FLAG_DETACH_XMAT)
	
end
function c26045009.afilter(c,tp)
	return c:IsSetCard(0x645)
	and c:IsType(TYPE_FIELD)
	and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c26045009.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c26045009.afilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,tp)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(26045009,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local sg=g:Select(tp,1,1,nil):GetFirst()
		Duel.ActivateFieldSpell(sg,e,tp,eg,ep,ev,re,r,rp)
	end
end
function c26045009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c26045009.efilter(c,tp)
	return c:IsSetCard(0x645)
	and c:IsFaceup() and c:CheckActivateEffect(true,true,false)~=nil
end
function c26045009.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingTarget(c26045009.efilter,tp,LOCATION_FZONE,0,1,nil,tp)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c26045009.efilter,tp,LOCATION_FZONE,0,1,1,nil,tp)
	Duel.HintSelection(g)
	local te=g:GetFirst():CheckActivateEffect(true,true,false)
	e:SetLabelObject(te)
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	Duel.ClearOperationInfo(0)
end
function c26045009.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	local te=e:GetLabelObject()
	if not te then return end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function c26045009.xyzfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetOverlayCount()>1 and c:GetSequence()>=5
end
function c26045009.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mn=Duel.GetFieldGroup(tp,LOCATION_DECK,0)>Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	local ex=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)>Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK+LOCATION_EXTRA,nil)>=1 and (mn or ex) and Duel.IsExistingTarget(c26045009.xyzfilter,tp,LOCATION_MZONE,0,1,nil) end
	local tg=Duel.SelectTarget(tp,c26045009.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c26045009.deop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) or not tc:IsType(TYPE_XYZ) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local g=tc:GetOverlayGroup():Select(tp,2,2,nil)
	Duel.SendtoGrave(g,REASON_COST)
	local mn=(Duel.GetFieldGroup(tp,LOCATION_DECK,0)>Duel.GetFieldGroup(tp,0,LOCATION_DECK))
	local ex=(Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)>Duel.GetFieldGroup(tp,0,LOCATION_EXTRA))
	local loc,dg,xg=0,Duel.GetFieldGroup(tp,0,LOCATION_DECK),Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if mn then
		loc=loc+LOCATION_DECK 
		Duel.ConfirmCards(tp,dg)	
	end
	if ex then
		loc=loc+LOCATION_EXTRA 
		Duel.ConfirmCards(tp,xg)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,loc,1,1,nil,tp)
	if #g>0 then
		Duel.Overlay(tc,g)
	end
end