--Hetredoxis Warheit
function c26043007.initial_effect(c)
	--Fusion Material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,false,false,26043001,26043002,26043003)
	--Extra Monsters cannot activate their effects
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetCondition(c26043007.accon)
	e1:SetValue(c26043007.aclimit)
	c:RegisterEffect(e1)
	--count
	if not c26043007.global_check then
		c26043007.global_check=true
		c26043007[0]=false
		c26043007[1]=false
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c26043007.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c26043007.clearop)
		Duel.RegisterEffect(ge2,0)
	end
	--Send 2 monsters with different names from extra deck to GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26043007,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c26043007.tgtg)
	e2:SetOperation(c26043007.tgop)
	c:RegisterEffect(e2)
	--DARK FUSION JUMPSCARE
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetCode(26043007)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTargetRange(1,0)
	c:RegisterEffect(e0)
end
function c26043007.checkop(e,tp,eg,ep,ev,re,r,rp)
	if c26043007[0] then return end
	local tc=eg:GetFirst()
	for tc in aux.Next(eg) do
		if tc:GetSummonLocation()==LOCATION_EXTRA then
			c26043007[0]=true
			if not c26043007[1] then
				if Duel.IsPlayerAffectedByEffect(0,26043007) or tc:IsCode(26043007) then
				Duel.Hint(HINT_CARD,1,26043007)
				elseif Duel.IsPlayerAffectedByEffect(1,26043007)or tc:IsCode(26043007) then
				Duel.Hint(HINT_CARD,0,26043007)
				end
				c26043007[0]=true
			end
		else return end
	end
end
function c26043007.clearop(e,tp,eg,ep,ev,re,r,rp)
	c26043007[0]=false
	c26043007[1]=false
end
function c26043007.accon(e,tp,eg,ep,ev,re,r,rp)
	return c26043007[0]
end
function c26043007.aclimit(e,re,tp)
	local rc=re:GetHandler()
	local mat=rc:GetMaterial()
	return not (rc:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)
	and mat:IsExists(c26043007.code,1,nil,mat,rc))
	and re:IsActiveType(TYPE_MONSTER)
end
function c26043007.code(c,mat,rc)
	local REASON=REASON_FUSION+REASON_SYNCHRO+REASON_XYZ+REASON_LINK 
	return rc:ListsCodeAsMaterial(c:GetCode()) 
	and c:GetReason()&REASON ~=0
end
function c26043007.cfilter(c,tp)
	local REASON=REASON_FUSION+REASON_SYNCHRO+REASON_XYZ+REASON_LINK 
	return c:IsAbleToRemove()
	and c:IsMonster()
	and c:GetReason()&REASON ~=0
	and not Duel.IsPlayerAffectedByEffect(tp,69832741)
end
function c26043007.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,nil)
	local g2=Duel.GetMatchingGroup(c26043007.cfilter,tp,0,LOCATION_GRAVE,nil,tp)
	if chk==0 then return #g1>0 and #g2>0 and e:GetHandler():GetFlagEffect(26043007)==0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_EXTRA)
end
function c26043007.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,nil,tp)
	local g2=Duel.GetMatchingGroup(c26043007.cfilter,tp,0,LOCATION_GRAVE,nil,tp)
	while #g1>0 and #g2>0 do
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local tc1=g1:Select(1-tp,1,1,nil):GetFirst()
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local tc2=g2:Select(1-tp,1,1,nil):GetFirst()
		g1:Sub(tc1);g2:Sub(tc2);
		Duel.Remove(Group.FromCards(tc1,tc2),POS_FACEUP,REASON_EFFECT)
		if (#g1==0 and #g2==0) or tc1:ListsCodeAsMaterial(tc2:GetCode()) or not Duel.SelectYesNo(tp,aux.Stringid(26043007,1)) then
			return
		end
	end
end