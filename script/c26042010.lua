--Bellows of Meggidon
function c26042010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_TOGRAVE,TIMING_TOGRAVE)
	e1:SetCost(c26042010.cost)
	c:RegisterEffect(e1)
	--act from hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c26042010.qpcond)
	c:RegisterEffect(e2)
	--to grave
	aux.GlobalCheck(c26042010,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetCondition(c26042010.regcon)
		ge1:SetOperation(c26042010.regop)
		Duel.RegisterEffect(ge1,0)
	end)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26042010,2))
	e3:SetCategory(CATEGORY_DECKDES+CATEGORY_LEAVE_GRAVE+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_CUSTOM+26042010)
	e3:SetLabel(0)
	e3:SetTarget(c26042010.tg)
	e3:SetOperation(c26042010.op)
	c:RegisterEffect(e3)
end
function c26042010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_GRAVE)
	e1:SetTargetRange(LOCATION_DECK,0)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_OATH)
	e2:SetDescription(aux.Stringid(26042010,4))
	e2:SetTargetRange(1,0)
	Duel.RegisterEffect(e2,tp)
end
function c26042010.qpcond(e,tp,eg,ep,ev,re,r,rp)
	local ch=Duel.GetCurrentChain(true)
	local ce,cp=Duel.GetChainInfo(ch,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_CONTROLER)
	local ex1,g1,gc1,dp1,dv1=Duel.GetOperationInfo(ch,CATEGORY_TOGRAVE)
	return (ex1 and (dv1&LOCATION_DECK)==LOCATION_DECK) and cp~=tp and not ce:IsHasCategory(CATEGORY_DECKDES)
end

function c26042010.regcon(e,tp,eg,ep,ev,re,r,rp)
	return r&REASON_EFFECT ~=0 and re:GetHandler():GetCode()~=26042010
end
function c26042010.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsPlayerAffectedByEffect(rp,26042010) then
		Duel.RaiseEvent(c,EVENT_CUSTOM+26042010,e,0,tp,0,0)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetCode(26042010)
		e3:SetRange(LOCATION_ONFIELD)
		e3:SetReset(RESET_CHAIN)
		e3:SetTargetRange(1,0)
		Duel.RegisterEffect(e3,rp)
	end
end
function c26042010.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsPlayerCanDiscardDeck(0,1) or Duel.IsPlayerCanDiscardDeck(1,1)) --and e:GetLabel()==1
	end
	local opt=Duel.SelectOption(tp,aux.Stringid(26042010,0),aux.Stringid(26042010,1))
	local p=(opt==0 and tp or 1-tp)
	Duel.SetTargetPlayer(p)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,p,1)
	e:SetLabel(0)
end
function c26042010.rfilter(c,tid)
	return c:IsAbleToDeck() and c:GetTurnID()==tid
end
function c26042010.op(e,tp,eg,ep,ev,re,r,rp)
	local tid=Duel.GetTurnCount()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if not e:GetHandler():IsRelateToEffect(e) or not Duel.DiscardDeck(p,d,REASON_EFFECT) then return end
	local g=Duel.GetMatchingGroup(c26042010.rfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,tid)
	if #g~=0 and Duel.SelectYesNo(tp,aux.Stringid(26042010,3)) then
		Duel.BreakEffect()
		sg=g:Select(tp,1,1,nil)
		Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
	end
end