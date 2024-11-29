--Hetredominion
function c26043010.initial_effect(c)
	--send to gy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26043010,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetTarget(c26043010.target)
	e1:SetOperation(c26043010.activate)
	c:RegisterEffect(e1)
	--chain mat
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26043010,2))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHAIN_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c26043010.chcon)
	e2:SetTarget(c26043010.chtg)
	e2:SetOperation(c26043010.chop)
	e2:SetValue(aux.TRUE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetOperation(c26043010.chk)
	e2:SetLabelObject(e3)
	--inactivatable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_INACTIVATE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetValue(c26043010.effectfilter)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_DISEFFECT)
	e5:SetRange(LOCATION_SZONE)
	e5:SetValue(c26043010.effectfilter)
	c:RegisterEffect(e5)
end
c26043010.listed_series={0x643}
c26043010.listed_names={CARD_POLYMERIZATION }

function c26043010.effectfilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	return te:GetHandler():IsCode(CARD_POLYMERIZATION)
end
function c26043010.hate(c)
	local mat=c:GetMaterial()
	return c:GetType()&TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK ~=0 and (not mat or not mat:IsExists(c26043010.hcode,1,c,c))
end
function c26043010.hcode(c,rc)
	return rc:ListsCodeAsMaterial(c:GetCode())
end
function c26043010.xtgfilter(c,tp)
	local tg=Duel.GetMatchingGroup(c26043010.thorg,tp,LOCATION_DECK,0,nil,c)
	return c:IsSetCard(0x643) and c:IsType(TYPE_FUSION) and c:IsAbleToGrave() and tg:GetClassCount(Card.GetCode)>1
end
function c26043010.thorg(c,tc)
	local code=c:GetCode()
	return tc:ListsCodeAsMaterial(code) and c:IsAbleToGrave()
end
function c26043010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26043010.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.GetMatchingGroup(c26043010.xtgfilter,tp,LOCATION_EXTRA,0,nil,tp)
	if #g>0 and Duel.GetFlagEffect(tp,26043010)==0 and Duel.SelectYesNo(tp,aux.Stringid(26043010,0)) then
		Duel.RegisterFlagEffect(tp,26043010,RESET_PHASE+PHASE_END,0,1)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		tg=Duel.GetMatchingGroup(c26043010.thorg,tp,LOCATION_DECK,0,nil,tc)
		Duel.SendtoGrave(tc,REASON_EFFECT)
		if #tg>1 then
			local sg=aux.SelectUnselectGroup(tg,e,tp,2,2,aux.dncheck,1,tp,HINTMSG_SELECT,nil,nil,true)
			Duel.ConfirmCards(1-tp,sg)
			local hg=sg:Filter(Card.IsAbleToHand,nil)
			if #hg>0 and Duel.SelectYesNo(tp,aux.Stringid(26043010,1)) then
				hg=hg:Select(tp,1,1,nil)
				Duel.SendtoHand(hg,nil,REASON_EFFECT)
				sg:Sub(hg)
			end
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end
function c26043010.chcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(c26043010.self,tp,LOCATION_ONFIELD,0,nil,c)
	return Duel.IsExistingMatchingCard(c26043010.hate,tp,0,LOCATION_MZONE,1,nil) and Duel.GetFlagEffect(tp,26043010)==0 and
	g:GetFirst()==c
end
function c26043010.self(c,tc)
	return c:IsCode(26043010) and c:IsFaceup() and not c:IsDisabled()
end
function c26043010.chfilter(c,e,tp)
	return c:IsMonster() and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c26043010.chfilter2(c,e,tp)
	return c:IsMonster() and c:IsCanBeFusionMaterial() and c:IsAbleToGrave() and c:IsSetCard(0x643)
end
function c26043010.chtg(e,te,tp,value)
	if value&SUMMON_TYPE_FUSION==0 then return Group.CreateGroup() end
	local g1=Duel.GetMatchingGroup(c26043010.chfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,te,tp)
	local g2=Duel.GetMatchingGroup(c26043010.chfilter2,tp,LOCATION_DECK,0,nil,te,tp)
	g1:Merge(g2)
	return g1
end
function c26043010.chop(e,te,tp,tc,mat,sumtype,sg,sumpos)
	if not sumtype then sumtype=SUMMON_TYPE_FUSION end
	tc:SetMaterial(mat)
	Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
	if sg then
		sg:AddCard(tc)
		Duel.RegisterFlagEffect(tp,26043010,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.SpecialSummon(tc,sumtype,tp,tp,false,false,sumpos)
	end
end
function c26043010.hetdom(c)
	return c:IsFaceup() and c:IsCode(26043010)
end
function c26043010.chk(tp,sg,fc)
	local hetg=Duel.GetMatchingGroup(c26043010.hetdom,tp,LOCATION_ONFIELD,0,nil)
	local dg=sg:Filter(Card.IsLocation,nil,LOCATION_DECK)
	return #dg<=#hetg
end