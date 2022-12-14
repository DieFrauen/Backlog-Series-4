--Xadres Board
function c26041010.initial_effect(c)
	--cannot spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetTargetRange(1,0)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	--e1:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c26041010.target)
	e1:SetOperation(c26041010.activate)
	c:RegisterEffect(e1)
	--normal summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26041010,1))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(c26041010.cond1)
	e2:SetTarget(c26041010.nstg)
	e2:SetOperation(c26041010.nsop)
	c:RegisterEffect(e2)
end

function c26041010.kfilter(c)
	return c:IsCode(26041001) and c:IsSSetable()
end

function c26041010.ffilter(c,tp)
	return c:IsCode(26041010) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c26041010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26041010.ffilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) and Duel.IsExistingMatchingCard(c26041010.kfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c26041010.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc1=nil
	local tg=Duel.GetMatchingGroup(c26041010.ffilter,tp,LOCATION_DECK,0,nil,tp)
	if #tg==tg:FilterCount(Card.IsLocation,nil,LOCATION_DECK) then
		tc1=tg:GetFirst()
	else
		tc1=tg:Select(tp,1,1,nil):GetFirst()
	end
	local tc2=Duel.GetFirstMatchingCard(c26041010.kfilter,tp,LOCATION_DECK,0,nil,tp)
	Duel.ActivateFieldSpell(tc1,e,1-tp,eg,ep,ev,re,r,rp)
	if Duel.SSet(tp,tc2,tp,true) then
		--Treated as a Continuous Trap
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc2:RegisterEffect(e1)
	end
	
end
function c26041010.cond1(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function c26041010.chfilter(c,e,tp)
	local mi,ma=c:GetTributeRequirement()
	local rg=Duel.GetReleaseGroupCount(tp,false)
	return c:IsSetCard(0x641) and c:IsSummonable(true,nil) and rg>=mi
end
function c26041010.nstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(Card.IsSummonable,tp,LOCATION_MZONE,0,nil,true,nil)
	local g2=Duel.GetMatchingGroup(Card.IsSummonable,tp,LOCATION_HAND,0,nil,true,nil)
	g1:Merge(g2)
	local g3=Duel.GetMatchingGroup(c26041010.chfilter,tp,LOCATION_SZONE,0,nil,e,tp)
	g1:Merge(g3)
	if chk==0 then return #g1>0 end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c26041010.nsop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsSummonable,tp,LOCATION_MZONE,0,nil,true,nil)
	local g2=Duel.GetMatchingGroup(Card.IsSummonable,tp,LOCATION_HAND,0,nil,true,nil)
	g1:Merge(g2)
	local g3=Duel.GetMatchingGroup(c26041010.chfilter,tp,LOCATION_SZONE,0,nil,e,tp)
	g1:Merge(g3)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local tc=g1:Select(tp,1,1,nil):GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end