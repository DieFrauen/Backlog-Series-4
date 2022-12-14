--Respite of the Superancients
function c26042008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c26042008.cost)
	e1:SetLabel(0)
	e1:SetTarget(c26042008.target)
	e1:SetOperation(c26042008.activate)
	c:RegisterEffect(e1)
	--to field
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c26042008.tpcon)
	e2:SetTarget(c26042008.tptg)
	e2:SetOperation(c26042008.tpop)
	c:RegisterEffect(e2)
	
end
function c26042008.rescon(sg,e,tp,mg)
	return sg:IsExists(Card.IsType,1,nil,TYPE_RITUAL) or sg:GetCount()==2
end
function c26042008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,c,REASON_COST)
	if chk==0 then return aux.SelectUnselectGroup(g,e,tp,1,2,c26042008.rescon,0) end
	local sg=aux.SelectUnselectGroup(g,e,tp,1,2,c26042008.rescon,1,tp,HINTMSG_DISCARD,c26042008.rescon)
	Duel.SendtoGrave(sg,REASON_COST+REASON_DISCARD)
end
function c26042008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_HAND)
	e1:SetTargetRange(LOCATION_DECK,0)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_OATH)
	e2:SetDescription(aux.Stringid(26042008,2))
	e2:SetTargetRange(1,0)
	Duel.RegisterEffect(e2,tp)
end
function c26042008.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c26042008.tpcheck(c)
	return c:GetPreviousLocation()==LOCATION_DECK 
end
function c26042008.tpcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:FilterCount(c26042008.tpcheck,nil)>0 and rp~=tp and (r&REASON_EFFECT)~=0
end
function c26042008.tptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	local ep=tp
	local opt=Duel.SelectOption(tp,aux.Stringid(26042008,0),aux.Stringid(26042008,1))
	local p=(opt==0 and tp or 1-tp)
	Duel.SetTargetPlayer(p)
end

function c26042008.tpop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=math.min(5,Duel.GetFieldGroupCount(p,LOCATION_DECK,0))
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_CONFIRM)
	local g=Duel.GetDecktopGroup(p,ct)
	if #g>0 then
		Duel.ConfirmCards(tp,g)
		Duel.SortDecktop(tp,p,ct)
	end
end